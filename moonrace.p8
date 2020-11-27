pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function un_sp(s)
 return unpack(split(s))
end

function mspl(s)
 local s2={}
 for ss in all(split(s,"&")) do
  add(s2,split(ss))
 end
 return s2
end

dr,db=split"1,0,0,-1,-1,0,0,1,1,-1,-1,-1,-1,1,1,1",split"-1,0,1,0,0,-1,0,1"
cartdata"moon_race"

function end_game()
 ents,mute_win,fast,h={},true
 fade_to(function()
  if mode==2 then
   _init()
   return
  end
 
  music"41"
  race_count+=1
  rc1,scr_pal=race_count+1
  for x=0,17 do for y=0,17 do
   mset(x,y,(x+y)%2==0 and 32 or 48)
  end end
  for p in all(scores) do
   p.rsc=9-p.pos
   p.csc=p.rsc+p.frags-p.death
   p.score+=p.csc
   if p.hum then 
    p.score+=.1
   end
  end  
  
  local e=mke()  
  e.dr=function()
   map(0,0,t16-16,t16-16,18,18)
   mfunc"rectfill,0,16,127,112,1,rect,-1,16,128,112,7"
   rectshade(un_sp"0,14,127,15")
   rectshade(un_sp"0,113,127,114")
  end
  
  mk_table(0)
 end)
end

function mk_table(k)
 ysort(scores,k==0 and "csc" or "score")
 
 local e=mke()
 local ready
 e.upd=function()

  if e.kl then   
   e.x=(e.x-2)*1.5
  else
   e.x*=.85
  end
  
  if btn"5" then  
   if ready and not e.kl then
    mfunc"sfx,7,-1,11,2"

		  if solo then   
		   for i=1,3 do
		    local p,save_score=scores[i]
		    if p.hum then
		     if k==0 then
		      save_score=p.id*4+race_count-1
		     elseif race_count==3 then
		      save_score=p.id*4+3
		     end
		     if save_score then
							 dset(save_score,max(4-i,dget(save_score)))
		     end
		    end
		   end
		  end		 
		  e.kl=true 
    if k==1 or mode>0 then
				 if race_count==3 or mode>0 then
				  fade_to(_init)
				 else
				  fade_to(init_game)
				 end
    else
     wt(9,mk_table,1)
    end		  
   end
  else
   ready=true
  end
 end
    
 e.dr=function(e,x,y)    
  camera(-x,-y)
  y=20
  ?k==0 and "pos kil pen tot" or "   score",64,y,13
  y+=10

  for p in all(scores) do  
   local cl=8+p.id
   pal(8,8+p.id)
   pal(2,sget(16+p.id,1))
   spr(128+p.id*16+4,12,y-2)
   ?ship_names[p.id+1],24,y,cl
   pal()
   
   --[[
   if p.hum then
    ?"p"..p.hum,2.5+cos(t/24+p.hum/4),y,7
   end
   --]]
   
   if k==0 then
	   ?p.rsc,68,y,p.dead and 8 or 7
    ?p.csc,116,y,7
    if p.frags>0 then
	    ?"+"..p.frags,84,y,7
	   end
	   
    if p.death>0 then
	    ?"-"..p.death,100,y,7
	   end 
	  else
	   ?flr(p.score),84,y,7
   end  
   y+=10
  end 
  
  -- medals
  if k==0 or race_count==3 then for i=1,3 do
   local p=scores[i] 
   if p.hum then
    local g=e.t-32
    if g==0 then 
     mfunc"sfx,8,-1,9,4"     
    elseif g==64 then
     mfunc"sfx,7,-1,24,8"
    end
--	   local c=1-mid(0,g/64,1)
--	   local cc=sqrt(c)*32
--	   local mx,my=2+c*96+cos(c*2)*cc,18+i*10+c*96+sin(c*2)*cc
	   
	   local lc=mid(0,g/64,1)
	   local c,slc=(1-lc)*3,sin(lc/2)
	   local mx,my=lc*2+(cos(c)*slc+c)*20,lc*(18+i*10)+(sin(c)*slc+c)*20
	   pal(pp[5-i])
	   if g>16 or g>0 and t42
	   then
		   if k==0 then
		    spr(34,mx,my)
		   else
		    if g>64 and g<96 and t42 then
		     apal"7"
		    end
	     spr(39,104-mx,my-4,2,2)
	     if g==64 then
	      for i=0,6 do
	       shockwave(112-mx,my+8,16,64+i*32,un_sp"24,0,1")
	      end
	     end
	     if g>64 then
	      local r=rnd"ffff.ffff"
						 srand"1"      
						 for i=0,32 do
						  local m=rnd()
						  print("◆",rnd"128"+cos(rnd()+t/64)*16*m,(rnd"128"+t*m)%136-8,8+rand"4")
						 end  
						 srand(r)
	     end     
		   end
	   end
	   
	   pal()
	  end
  end end
  
  -- title & footer
  function f()
   s=k==0 and "race result" or "championship ("..race_count.."/3)" 
   for i=1,#s do   
    ?sub(s,i,i),x+60+i*4-#s*2,4.5+sin(i/16+t/24),7
   end
	  if e.t>16 and t16<12 and not e.twc then
	   ?un_sp"press ❎ to continue,24,119,7"
	  end   
  end
	 apal"1"
	 for i=0,7 do
	  camera(dr[i*2+1],dr[i*2+2])
	  f()
	 end
	 mfunc"camera,pal"
	 f()    
 end
 e.x=128
 
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

function init_game()
 local mus=split"4,25,33"
 music(mus[rc1],0,8)

 mfunc"memset,0x5f70,0,15"
 map_width,map_dx,players,wps,mdrs,ents,shades,finish_count,space,smi,mute_win=map_ws[rc1],map_xs[rc1],{},{},solo and drs or drs_basic,{},{},0,race_count==2,1

 -- map
 mp=mke()
 mp.dp,mp.⧗start=0,97

 mp.dr=function()
  map_pal(rc1)
  
  local mpx,mpy,mpw,mph=max(cmx\8,0),cmy\8,win.ww/8+1,win.hh/8+1
  mpw-=max(mpx+mpw-map_width,0)  
  mph-=max(mpy+mph-32,0)  
  map(mpx+map_dx,mpy,mpx*8,mpy*8,mpw,mph) 
  scr_pal=race_count==1 and split"129,130,131,4,133,134,15,136,137,9,139,12,5,14,143,0"
 end
 
 mp.upd=function() 
  -- bounce players
	 for i,a in ipairs(players) do for j=i+1,#players do
	  local b=players[j]
	  local dx,dy,lm=a.x-b.x,a.y-b.y,8
	  if abs(dx)<lm and abs(dy)<lm then
	   local dd=lm-sqrt(dx^2+dy^2)
	   if dd>0 then
	    col_hit(a,b,dd)
	    col_hit(b,a,dd)   
	   end   
	  end
	 end end
	 
	 -- sort players
	 ysort(scores,"len")
	 local pos=1
  for sc in all(scores) do 
   if not sc.finish then
	   sc.pos=pos
	   --pl.tbl.pos=9-pos
   end
   pos+=1
  end 
	 
 
  -- dust detector
  for i=1,#players do
   local e=players[1+(i+smi)%#players]
		 if e.thrust then
		  smi+=1
		  local x,y=e.x-cos(e.an)*4,e.y-sin(e.an)*4
		  if not fg(x/8,y/8,5) and not space then
		   local a,e=e.an+.5+rnd".2"-.1,mk_dust(x,y)   
		   impulse(e,a,rnd"3")
		   break   
		  end		  
		 end 
  end
 
  if finish_count>=#players then
   finish_count=-1
   wt(16,end_game)
  end
 end
 
 -- waypoints hhh
 local path=path[rc1]
 for i=0,#path-1,2 do
  local wp={
   x=path[i+1],
   y=path[i+2],
  }
  add(wps,wp)  
 end

 for i=0,#wps-1 do
  local wp=wps[i+1]
  wp.prev,wp.next,wp.id=wps[(i-1)%#wps+1],wps[(i+1)%#wps+1],i
 end
 for wp in all(wps) do
  local aa,ab=wpa(wp),wpa(wp.prev)
  local pa=ab+hmod(aa-ab,.5)/2+.25
  wp.pa,wp.px,wp.py=pa,wp.x+cos(pa)*4,wp.y+sin(pa)*4
 end
 fwp=wps[1]
 
 -- players
 local pmax=8
 for i=0,pmax-1 do
  local f=function(n)
   return chars[n*4+ships[i+1][n+1]]+0
  end
	 local e=mke(16)  
	 e.x,e.y,e.upd,e.cl,e.nwp,e.drs,e.pcol,e.pid,e.z,e.lap,e.an,e.hid=fwp.x-(pmax-i-1)*12,fwp.y+(i%2*2-1)*4+2,upd_car,8+i,fwp.next,mdrs,pcol,i,un_sp"-1,0,0,true"
	 for sc in all(scores) do
	  if sc.id==i then
	   e.tbl,sc.ship,sc.frags,sc.death,sc.finish=sc,e,0,0
	  end
	 end
	 e.acc,e.steer,e.brake,e.cross,e.wcd,e.hull=f"0",f"1",f"2",f"3",f"4",f"5"
	 
	 reset_weapon(e)
	 e.weap+=rand"3"-3
	 e.hull_max,e.dr=e.hull,function (e,x,y)
		 if e.⧗shield then
		  local f=e.⧗hit_shield and circfill or circ
		  f(x+3,y+3,5+t2,e.⧗hit_shield and 7 or 8)
		 end
		 --[[ show wp
		 if e.ttx then
		  spr(37,e.ttx-4,e.tty-4)
		 end
		 --]]
		end	 
	 add(players,e)
 end 
 
 --
 for w in all(windows) do
  w.trg=players[w.sel+1]
  w.trg.hum=w.pid
  w.trg.weap/=2
 end
 
 --
 if mode==2 then
  for p in all(players) do
   if p.hum then
    kl(p)    
   end  
  end
 end 
  
 --
 if #windows<3 then
  cast_shades(0,0,map_width,32)
 end
 -- inter
 local e=mke()
 e.dp,e.dr=10,function()
 
 for w in all(windows) do
  local h=w.trg


  camera(-w.x,-w.y)
  mfunc"spr,5,pal"
  ?w.trg.tbl.pos,1,1,h.cl

  -- weapons	 
	 if h.weap<0 then
	  rectfill(w.ww-3,w.hh+h.weap-3,w.ww-8,w.hh-3,h.cl)
	 else	 
	  local x,y=w.ww-12,w.hh-12
	  rectfill(x-1,y-1,x+8,y+8,1)
	  --rect(x-2,y-2,x+9,y+9,t%2==0 and 7 or h.cl)
	  rect(x-2,y-2,x+9,y+9,8+t%3)
	  spr(112+h.weap,x,y)
	 end  
	 
	 -- life
	 for i=1,h.hull do
	  pal(8,h.cl)
	  spr(6,3+i*2)
	 end
	 
	 -- time
	 --[[
	 if mode==2 then
	  local s=gts(h.t)
	  print(s,2,win.hh-7,h.cl)
	 end
	 --]]
	 
	 -- start count
	 if mp.⧗start then
	  local n,c=mp.⧗start\24,mp.⧗start%24/24
	  local y=w.hh/4+sin(n>0 and c/2 or c/4+.25)*8
	  if n*24==mp.⧗start then
	   if n>1 then
	    mfunc"sfx,7,-1,18,1"
	   else
	    mfunc"sfx,7,-1,19,5"
	   end
	  end 
	  for i=0,1 do 
		  apal"7"
	   if i==0 then
	    apal(11-n)
	   end
	   local x=w.ww/2-i-4
		  if n>0 then
		   palt(split"0b1011111011111111,0b1101110011111111,0b1111010011111111"[n])
		   spr(57,x,y-i)
		   pal()
		  else
		   spr(58,x-8,y-i,3,1)
		  end
		  pal()
	  end
	 end
 end
 end
end

function out_win(e)
 local x,y,m=e.x-cmx,e.y-cmy,8
 return x>win.ww+m or y>win.hh+m or x<-m or y<-m
end


function mk_dust(x,y)
 local e=mke(7,x-4,y-4)
 e.drs,e.scl,e.z,e.vz,e.hid,e.frict,e.life=mdrs,un_sp"13,1,-1,true,.95,16"
 e.upd=function()
  e.fr=15-e.life/2
 end 
 return e
end


function cast_shades(sx,sy,xmax,ymax)
 local a=split"-1,0,0,-1,-1,-1"
 for x=sx,xmax-1 do for y=sy,ymax-1 do
  local k=x..","..y
  if shades[k] then
   kl(shades[k])
  end
  if not fg(x,y,0) then
   local tl
   for i=0,2 do
    local nx,ny=x+a[1+i*2],y+a[2+i*2]
    if fg(nx,ny,0) then
     tl=42+i
    end
   end 
   if tl then
    local e=mke(tl,x*8-1,y*8-1)
    shades[k],e.dr,e.hid,e.nfr=e,drs,true,true

   end   
  end 
 end end

end

function pcol(x,y)
 return fg(x/8,y/8,0)
end

function shockwave(x,y,ra,rb,t,pl,hl,light)
 local e=mke(0,x,y)
 e.life,e.hole,e.mpl=t,hl or .6,8
 
 e.dr=function(e,x,y)
  local c=e.life/t
  local f,cl=c>e.hole and circfill or circ,sget(c*e.mpl,pl)
  f(x,y,ra+(rb-ra)*(1-c*c),cl)

  if light then  
	  local f=function(x)
	   return x+rnd"20"-10
	  end  
		 local x,y=f(x),f(y)
	  for i=0,5 do
	   local nx,ny=f(x),f(y)
	   line(x,y,nx,ny,7)
	   x,y=nx,ny
   end
  end
  
 
  
 end
 return e 
end


function ysort(a,s)
 for i=1,#a do
  local j=i
  while j>1 and a[j-1][s]<a[j][s] do
   a[j],a[j-1]=a[j-1],a[j]
   j-=1
  end
 end
end


function rectshade(ax,ay,bx,by)
 for x=ax,bx do 
  for y=ay,by do
   local cl=sget(8+pget(x,y),1)
   pset(x,y,cl)
  end 
 end
end


function drs_basic(e)
 if out_win(e) then
  return
 end
 apal(e.scl or 1)
 spr(e.fr,e.x+e.drx,e.y+e.dry)
 pal()
end

function drs(e)
 if out_win(e) then
  return
 end
  
 for dx=0,e.ww-1 do for dy=0,e.hh-1 do
  local x,y,px,py=e.x+dx,e.y+dy,e.fr%16*8,e.fr\16*8
  local pcl=sget(px+dx,py+dy)
  if pcl>0 then  
   x+=1+e.drx
   y+=1+e.dry
   local gc=pget(x,y)
   if gc>0 then
    pset(x,y,pcl==15 and (gc<6 and 0 or sget(8+gc,2)) or sget(8+gc,1))
   end
   --pset(x,y,pcl==15 and 0 or sget(8+pget(x,y),1))
  end  
 end end
end

function apal(n)
 for i=0,15 do pal(i,n) end
end

function col_hit(a,b,dd)

 local dx,dy=a.x-b.x,a.y-b.y
 local an=atan2(dx,dy)
 dx,dy=cos(an)*dd,sin(an)*dd

 local wa,wb=a.⧗shield and 100 or 1,b.⧗shield and 100 or 1
 local wc=wb/(wa+wb)
 pmov(a,dx*wc,dy*wc)
 
 if a.⧗shield then  
  a.⧗hit_shield=3
  return
 end
 
 
 local dv=sqrt((a.vx-b.vx)^2+(a.vy-b.vy)^2)
 if (dv>2 or b.⧗shield) and not a.⧗hit then
  sfx(8,-1,rand"4",1)
  hit(a,b.⧗shield and 2 or 1,b)
 end  
  
 -- shield bounce
 if b.⧗shield then
  impulse(a,an,2)
 end

 a.vx+=dx*wc/2
 a.vy+=dy*wc/2
end

function hit(e,n,from)
 if e.⧗shield then
  e.⧗hit_shield=3
	else
	 e.⧗hit,e.⧗burn=8,10+n*6
	 if not e.tbl.finish then
		 e.hull,e.killer=max(e.hull-n,0),from
	 end	 
	end
end

function dist(a,b,c,d)
 return sqrt((a/100-c/100)^2+(b/100-d/100)^2)
end

function fg(x,y,fl)

 if x>=0 and y>=0 and x<map_width and y<32 then
  return fget(mget(x+map_xs[rc1],y),fl)
 end
end

function upd_car(e)
 function bh(n) return bhv[n+e.pid*3] end
 

 local tx,ty,px,py,road=e.nwp.x,e.nwp.y,e.x/8,e.y/8
 local road,heal_pad=fg(px,py,5),fg(px,py,3)
 if road and e.dp>-1 then
  --gpp
	 local w=e.nwp
	 local d1,d2,d=dist(e.x,e.y,w.x,w.y),dist(e.x,e.y,w.px,w.py),dist(w.x,w.y,w.px,w.py)  
	 local t=(d1*d1-d2*d2)/d+d
	 t/=2
	 local al=mid(-bh(3),t/d,bh(3)) -- -4
	 tx,ty=w.px*al+(1-al)*w.x,w.py*al+(1-al)*w.y
  e.offroad,e.dp=0,1
 elseif space then
  e.offroad+=1
  if e.offroad>=48 then
   e.dp,e.drs=-1
  end
  if e.offroad>=80 then
   explode(e,true)
   return
  end  
 end

 e.ttx,e.tty=tx,ty

 local dx,dy=tx-e.x,ty-e.y
 local dd,sd=sqrt(dx^2+dy^2),gside(e.nwp.x,e.nwp.y,e.nwp.px,e.nwp.py,e.x,e.y)
 if sd>0 or (e.nwp!=fwp and dd<10) then
  if e.nwp==fwp then
   e.lap+=1   
   if e.lap==3 then
    e.tbl.finish=true
    finish_count+=1
   end
  end
  e.nwp,dd=e.nwp.next,128
 end


 --
 e.spd,e.thrust=sqrt(e.vx^2+e.vy^2),false
 

 -- turning
 local an=atan2(dx,dy) 
 local tsp=e.spd+2
 an=atan2(cos(an)*tsp-e.vx,sin(an)*tsp-e.vy)
 
 local da=hmod(an-e.an,.5)
 
 if e.⧗roll then
  e.an+=e.⧗roll/128
 else
  e.an+=mid(-e.steer,da,e.steer) 
 end

 -- 
 local shoot 
 if not e.hum or e.tbl.finish then  
  -- control
  e.thrust=abs(da)<bh(1) and e.spd<sqrt(dd)/bh(2) and not (heal_pad and e.hull<e.hull_max/2 and e.lap<3-1)
  -- fire
  function e:aim(tda_mind_maxd)
		 local tda,mind,maxd,res=un_sp(tda_mind_maxd)
		 for pl in all(players) do if pl!=e then
		  local dx,dy=pl.x-e.x,pl.y-e.y
		  if abs(dx)<maxd and abs(dy)<maxd then
		   local da=hmod(atan2(dx,dy)-e.an,.5)
		   if abs(da)<tda then
			   local dd=sqrt(dx^2+dy^2)
			   if dd<mind then
			    return
			   end  
			   if dd<maxd then
			    res=true
			   end
			  end
		  end
		 end end
		 return res
		end
		
  local eweap=e.weap
  if eweap==0 then
   shoot=e:aim".02,16,60"
  elseif eweap==1 then
   shoot=road and e:aim".12,0,32"
  elseif eweap==2 then
   shoot=e:aim".12,0,32"
  elseif eweap==3 then
   shoot=dd>40 and abs(da)<.05
  elseif eweap==4 then
   shoot=e:aim".5,0,32"
  elseif eweap==5 then
   shoot=not e:aim".12,0,32"
  elseif eweap==6 then
   shoot=#zone(e,24)>=1 or (e.⧗shocked and e.⧗shocked<42)
  end
 else
  e.thrust,shoot=btn(❎,e.hum),btnp(🅾️,e.hum) and e.weap>=0
 end
 
 e.thrust=e.thrust or e.⧗boost
 if (mp.⧗start and mp.⧗start>24) or e.⧗shocked then
  e.thrust=false
 else
	 --dash pad
	 if fg(px,py,7) then
	  e.⧗boost=12
	 end
 end
 
 -- thrust
 if e.thrust then
	 e.vx+=cos(e.an)*e.acc
	 e.vy+=sin(e.an)*e.acc 
 end
 
 -- weapon
 if shoot then
  if e.weap==0 then
   fire_mis(e,0) 
  elseif e.weap==1 then
		 e.minecount,e.last_mine=3
  elseif e.weap==2 then
   e.⧗machinegun=80
  elseif e.weap==3 then
   e.⧗boost=12
  elseif e.weap==4 then
   e.⧗shield=240
  elseif e.weap==5 then
   fire_mis(e,1) 
  elseif e.weap==6 then
		 e.⧗shocked=nil
		 mfunc"sfx,6,-1,2,12"
			shockwave(e.x,e.y,un_sp"32,32,6,5,0.25,true")
		
		 local a=zone(e,32)
		 for p in all(a) do
		  if not p.⧗shield then
		   p.⧗shocked=48
		  end
		 end
  end

  reset_weapon(e)
 end
 
 -- boost
 if e.⧗boost then
  e.vx+=cos(e.an)*.5
  e.vy+=sin(e.an)*.5
 end
 
 -- frict
 e.frict=e.thrust and .98 or e.brake
 if not road or fg(px,py,1) then
  e.frict=e.cross
 end 

 -- bonus
 if e.weap<0 and t%24==0 then
  e.weap+=1
  if e.weap>=0 then   
   e.weap=rnd(sweap[e.pid+1])
   --e.weap=0
  end
 end
 
 -- mine drop
 if e.minecount then
  local l=e.last_mine
  if not l or dist(l.x,l.y,e.x,e.y)>.16 then
   mfunc"sfx,8,-1,8,1"
   l=mke(33,e.x,e.y,0)
   l.from,l.wp,l.cl,l.drx,l.dry,l.br,l.dmg=e,e.nwp,e.cl,un_sp"-3,-3,5,3"
   l.upd=function()
    if not l.⧗shocked then
	    chk_blast(l)
	   end
    if not l.life and l.t>48 and #players>0 and scores[1].ship.nwp.prev==l.wp then
     l.life,l.blk=48,24
    end    
   end      
   e.last_mine=l
   e.minecount-=1
   if e.minecount==0 then
    e.minecount=nil
   end
  end
 end
 
 --machinegun
 if e.⧗machinegun and t%3==0 then
  mfunc"sfx,6,-1,0,1"
  local ox,oy,p=e.x,e.y,mke(0,e.x,e.y)
  p.vx,p.vy,p.life=cos(e.an)*5,sin(e.an)*5,16
  p.upd=function()
   ox,oy=p.x,p.y
   for pl in all(players) do
    if pl!=e and ecole(pl,p,4) then
     hit(pl,1,e)
     kl(p)
     return
    end
   end
  end  

  p.dr=function(e,x,y)
   line(ox,oy,x,y,7)
  end  
 end

 -- frame
 e.drx,e.dry,e.fr=-3,-3,128+e.pid*16+flr((e.an*16+.5)%16)
 e.z+=(-e.spd*2-e.z)*.15
 
 -- sfx
 if e.hum then
  poke(0x3200,min(e.spd\0.0625,63)+128)
  poke(0x3201,3)
  mfunc"sfx,0,0,0,1" 
  if e.thrust then
   mfunc"sfx,9,1,0,1"
  end  
  
 end
 
 -- score
 e.tbl.len=e.lap*500+e.nwp.prev.id*5-dd/100
 
 -- explode
 if e.hull==0 then
  explode(e)
 end

 -- healing
 if e.hull<e.hull_max and t8==0 and heal_pad then
  e.hull+=1
  e.⧗heal=4
  if e==h then mfunc"sfx,7,-1,13,5" end
 end
end




function zone(e,r)
 local a={}
 for p in all(ents) do
  if p!=e and p.cl and dist(p.x,p.y,e.x,e.y)<=r/100 then
   add(a,p)
  end
 end
 return a
end

function reset_weapon(e)
 e.weap=-e.wcd
 if not e.hum then e.weap*=2 end
end

function respawn(e,t)
 if t>0 then
  
  e.x,e.y=e.nwp.prev.x,e.nwp.prev.y  

  wt(24,respawn,e,t-1)  
	
	 local cl,x,y,tm=e.cl,e.x,e.y,mke()
  tm.dr=function(e)
   ?t,x-1,y-2,cl
   circ(x,y,27-e.t,cl)
  end
  tm.life=24
 else
	 e.hull,e.vx,e.vy,e.offroad,e.dp,e.killer,e.⧗roll=e.hull_max,un_sp"0,0,0,1"
	 add(ents,e)
	 add(players,e) 
 end
end

function explode(e,fall)
 
 kl(e)
 
 --e.dead,e.⧗hit=true
 e.⧗hit=nil
 local x,y=e.x,e.y
 e.tbl.death+=1
 
 if e.killer then
  e.killer.tbl.frags+=1
 end

 -- respawn
 wt(24,respawn,e,3)
  
 if fall then
  return
 end
 
 kl(e)
 mfunc"sfx,7,-1,24,8"
 
 --
 mp.⧗shk=8
 -- ground mark
 local p=mke(46,x-8,y-8,0)
 p.drs,p.invis,p.ww,p.hh,p.life=drs,un_sp"true,16,16,240"
 p.upd=function()
  if rand(p.life)>160 then
   mk_dust(x+rand"5"-2,y+rand"5"-2)
  end
 end
 p.dr=function()
  pset(x,y,8+t8)
 end
 -- shockwave
 shockwave(x,y,un_sp"8,16,16,0")
 shockwave(x,y,un_sp"8,96,8,0,1")
 
 --
 boom(x,y,8)
end

function boom(x,y,pmax)
 -- flames
 for i=0,7 do
  x+=rnd"6"-3
  y+=rnd"6"-3
  local e=shockwave(x,y,8,1,16+rand"32",0,0)
  e.dp=2
  e.vy=-rnd()
 end

 -- parts
 for i=1,pmax do
  local an,p=i/pmax,mke(38,x,y,2)
  p.vz,p.we,p.frict,p.ww,p.hh,p.z=-3-rnd"4",un_sp".2,.96,4,4,-1"
  impulse(p,an,2+rnd"4")
  p.life,p.drs=24+rand"48",mdrs
  p.flx=rnd()<.5
  if i>4 then
   p.⧗burn=8+rand"16"
  end
 end
end

function fire_mis(sh,mt)
 mfunc"sfx,7,-1,0,2"
 local e=mke(0,sh.x,sh.y+sh.z)
 local spd=sh.spd+2
 e.vx,e.vy=cos(sh.an)*spd,sin(sh.an)*spd 
 e.from,e.dmg,e.br=sh,5,8
 e.dr=function(e,x,y)
  circfill(x,y,1+t2*2,sget(125+t2,8+e.missile))
 end
 e.missile,e.pcol=mt,pcol

 if mt==0 then
  e.frict,e.life=1.05,60  
  return
 end
 
 -- homing
 e.dmg=3
 e.upd=function(e)
 
  for sc in all(scores) do
   local p=sc.ship
   if p!=sh then
    local dx,dy=p.x-e.x,p.y-e.y
    local ta,ca=atan2(dx,dy),atan2(e.vx,e.vy)
    ca +=hmod(ta-ca,.5)*.05
    e.vx,e.vy=cos(ca)*3,sin(ca)*3
    break
   end
  end
 end
end

function impulse(e,a,spd)
 e.vx+=cos(a)*spd
 e.vy+=sin(a)*spd
end


function chk_blast(e)
 for pl in all(players) do
  if pl!=e.from and ecole(pl,e,6) then
   blast(e)
  end
 end
end

function trail(x,y,cl,prev)
 local e=mke(0,x,y,1)
 e.hid,e.life,e.p=true,8,prev

 if prev then e.dr=function(e,x,y)
  local ex,ey=e.p.x,e.p.y
  if e.life<8 then
   local c=e.life/8
   ex,ey=x+(ex-x)*c,y+(ey-y)*c   
  end  
  
  local k=e.double and 1 or 0
  for dx=-k,k do for dy=-k,k do
   local cl=sget(120+e.life,cl)
   line(x+dx,y+dy,ex+dx,ey+dy,cl)
  end end 
 end end
 
 e.nxt=function()
  e.p=nil
 end
 return e
end


function ecole(a,b,r)
 local dx,dy=a.x-b.x,a.y-b.y
 if abs(dx)<r and abs(dy)<r then
  return sqrt(dx*dx+dy*dy)<r
 end
end

function blast(e)
 local r=e.br
 mfunc"sfx,8,-1,4,4"
 
 kl(e)
 -- collision 
 for pl in all(players) do
  local dx,dy=pl.x-e.x,pl.y-e.y
  
  if abs(dx)<r+3 and abs(dy)<r+3 then
	  local dd=sqrt(dx*dx+dy*dy) 
	  if dd<r+3 and not pl.⧗shield then
	   local an,imp=atan2(dx,dy),(r+3-dd)/2
	   pl.vx+=cos(an)*imp
	   pl.vy+=sin(an)*imp
	   pl.⧗roll=e.dmg*4
	   hit(pl,e.dmg,e.from)
	  end 
	 end
 end
 
 -- fx
 shockwave(e.x,e.y,r+2,r+8,10,0)
 shockwave(e.x,e.y,r+8,un_sp"48,16,3,1")
 for i=1,16 do
  local f=function()
   local e=shockwave(e.x,e.y,2,4,4+rand"8",0,0)
   e.we=-.1
		 e.x+=rnd"16"-8
		 e.y+=rnd"16"-8
  end
  wt(i,f)
 end
end

function fad(n,nxt) 
 local sn=fd 
 local f=function(e) 
  fd=sn+(n-sn)*e.t/16
 end 
 loop(f,16,nxt)
end

function fade_to(nxt)
 fad(8,function()
  ents={}
  mfunc"reload,0,0,0x3100"
  nxt()
  fad"0"
 end)
end

function rand(n)
 return flr(rnd(n))
end

function dr_flame(e)
 if e.thrust then
	 spr(36+t2,e.trx-3,e.try-3)
 end
end

function dre(e)
 if e.invis or (e.blk and e.life<e.blk and t42) then
  return
 end
 
 if e.hid and out_win(e) then
  return
	end
 
 local fr,x,y=e.fr,e.x+e.drx,e.y+e.dry+e.z

 -- sel
 if e.sel and t42 then
  fr+=1
 end
 
 if e.⧗hit and t2==0 then
  apal"8"
 end
 
 if e.⧗heal then
  apal"11"
 end
 
 if e.cl then
  pal(8,e.cl)
  pal(2,sget(e.cl-8,2))
 end
 
 if e.weap and e.an%1>=.5 then
  dr_flame(e)
 end  
 
 if e.offroad>=12 then
  for i=0,15 do
   pal(i,sget(8+i,min(e.offroad/12,5)))
  end
 
 end
 
 -- draw
 if fr>0 and not e.nfr then
  spr(fr,x,y,e.ww/8,e.hh/8,e.flx)
 end
 if e.dr then e.dr(e,x,y) end

 --
 if e.pid and e.an%1<.5 then
  dr_flame(e)
 end 
 if e.⧗shocked then for i=0,e.⧗shocked>>3 do
  line(x+rand"8",y+rand"8",x+rand"8",y+rand"8",12)
 end end
 
 pal()
end

function starfield(h)
 local r,starpal=rnd"ffff.ffff",mspl"1&7,1&7,13,1&7,7,13,1"
	srand"1"
	for i=1,h/2 do
	 local siz,x,y=rand"4"+1,rand"256",rand(h)
	 if win then
	  x-=cmx*siz/5
	  y-=cmy*siz/5
	 else
	  x+=t*siz\16
	 end
	 x,y=x%138-10,y%138-10
	 
	 pal(starpal[siz])
	 palt((split"0xbfff,0x9fff,0x8fff,0x87ff")[siz])
	 spr(99,x,y)
	end
	pal()
	srand(r)
end

-->8
-- engine
function mke(fr,x,y,dp)
 return add(ents,{
  fr=fr or 0,
  x=x or 0,
  y=y or 0,
  z=z or 0,
  dp=dp or 1,
  drx=0,dry=0,
  t=0,offroad=0,stress=0,
  vx=0,vy=0,vz=0,we=0,frict=1,
  ww=8,hh=8
 })
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
   e[v]=n>0 and n or nil
  end
 end

 -- trail
 if e.pid then 
	 if e.thrust or e.⧗boost then 
		 e.trx,e.try=e.x-cos(e.an)*4,e.y+e.z-sin(e.an)*4 
	  e.ptr=trail(e.trx,e.try,e.pid,e.ptr)
	  e.ptr.double,e.ptr.dp=e.⧗boost,e.dp
	 else
	  e.ptr=nil
	 end
	end 
 
 -- missile
 if e.missile then 
  chk_blast(e) 
  e.ptr=trail(e.x,e.y,8+e.missile,e.ptr)
 end
 
 -- burn
 if e.⧗burn then
  local sz=mid(1,e.⧗burn/6,2)
  local e=shockwave(e.x+rand"3"-1,e.y+e.z+rand"3"-1,sz,sz,4,0,0)
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
 del(players,e)
 if e.nxt then
  e.nxt()
  e.nxt=nil
 end
end

function loop(f,t,nxt)
 local e=mke()
 e.upd,e.nxt,e.life=f,nxt,t
end

function wt(t,f,a,b,c)
 local e=mke()
 e.life,e.nxt=t,function() f(a,b,c) end
end

function pmov(e,dx,dy)
 if ecol(e) then
  return
 end
 
 local bnc=not dx
 
 if bnc then
  dx,dy=e.vx,e.vy
 end
 
 tpx,tpy=nil
 local clx,cly
 
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
	 if e.missile and (clx or cly) then
	  blast(e)
	 end	
	  
	 if tpx and fg(tpx,tpy,0) then
	  local dmg=sqrt(dx*dx+dy*dy)\1
	  if dmg>=2 or e.stress>=30 then
		  mset(tpx+map_dx,tpy,32)
		  cast_shades(tpx-1,tpy-1,tpx+2,tpy+2)
		  boom(tpx*8+4,tpy*8+4,3)
		  mfunc"sfx,8,-1,4,4"
		  if e.pid then
		   hit(e,dmg)
		  end
		 else
		  e.stress+=10
	  end	  
	 end
	 if e.stress>0 then	 
	  e.stress-=1
	 end
	 
 end
end

function ecol(e,dx,dy)
 dx,dy=dx or 0,dy or 0 
 local k,a=.25,split"-.25,-.25,-.25,.25,.25,.25,.25,-.25"
 for i=0,3 do
  local x,y=e.x+a[i*2+1]*(e.ww-1)+dx-3,e.y+a[i*2+2]*(e.hh-1)+dy-3
  if e.pcol(x,y) then
   tpx,tpy=x\8,y\8
   return true 
  end
 end
end

function _update()
 t+=1
 t42,t16,t8,t2=t%4<2,t%16,t%8,t%2
 foreach(ents,upe)
end

function _draw()
 cls(race_count==2 and 0 or 6)
 if windows and not mute_win then
	 foreach(windows,function(w)
		 win,h,bcl=w,w.trg,7
		 if not test_win then
		  clip(w.x,w.y,w.ww,w.hh)
		 end
		 
		 if h then
		  bcl=h.⧗hit and 8 or 7
			 if h.tbl.finish then
			  cmx,cmy=fwp.x-w.ww/2,fwp.y-w.hh/2
			 else
				 local m=race_count<2 and 32 or 128
				 cmx,cmy=mid(-m,h.x-w.ww/2,map_width*8+m-w.ww),mid(-m,h.y-w.hh/2,256+m-w.hh)
				end
				-- bg
				mfunc"camera,0,0"
--				color(race_count==2 and 0 or 6)
--			 mfunc"rectfill,0,0,127,127"
		  if space then 
		   starfield"128"
		  end
		
			 -- camera
			 camera(cmx-w.x,cmy-w.y)
		 end
		 
		 for i=-1,2 do  
		  dr_ents(i)
		 end
		 camera()
		
		 rect(w.x,w.y,w.x+w.ww-1,w.y+w.hh-1,bcl)
		end)
	 clip()
 else
	 for i=0,2 do  
	  dr_ents(i)
	 end
 end
 
 -- inter
 camera()
 dr_ents(10)
 camera()
 
 -- minimap
 if windows and #windows==8 then
	 map_pal(rc1)
		mfunc"rectfill,43,43,82,82,6"
		local factor=map_ws[rc1]/40
		for i=0,31/factor do
		 local y=64+i-16/factor
		 tline(43,y,
		       82,y,
		       map_xs[rc1],i*factor,factor,0)
		end
		pal()
		for p in all(players) do
		 pset(43+p.x/factor/8,64-16/factor+p.y/factor/8,p.cl)
		end
 end

 -- fade
 mfunc"clip,pal"
 if fd>0 then
  for layer=1,4 do
   local c=(fd-layer+4)/16-.25
   local sc,lc=-70*sin(c),split"13,5,1,0"[layer]
   rectfill(0,0,127,sc,lc)
   rectfill(0,127-sc,127,127,lc)
  end
 end
 
 if scr_pal then
  pal(scr_pal,1) 
 end

end

function dr_ents(n)
 for e in all(ents) do
  if n==1 and e.drs then 
   e.drs(e)    
  end
  if e.dp==n then dre(e) end
 end
end
-->8
-- data
map_ws,map_xs,path,ships,sweap,chars,bhv,caracs,ship_names,s_desc,pp=split"32,40,56",split"0,32,72",mspl[[
129,17,199,17,215,17,228,24,233,38,226,53,212,58,149,58,133,63,128,77,130,122,141,135,160,145,208,144,225,149,231,162,232,211,228,228,215,237,169,234,121,213,99,213,83,229,22,229,13,211,12,185,18,173,32,175,45,181,62,181,73,168,73,154,67,144,51,135,22,79,20,40,25,24,40,17&
105,17,122,17,139,38,139,58,142,81,148,98,155,110,169,116,181,111,191,101,191,75,195,57,232,18,262,16,276,23,278,42,265,60,252,79,247,96,248,136,251,178,254,204,264,220,289,219,301,202,301,178,290,159,268,157,207,157,180,186,171,215,159,226,141,226,130,214,128,168,113,158,96,164,57,210,48,216,34,216,22,213,15,198,20,151,28,137,77,94,86,77,81,61,66,55,23,57,9,43,12,24,24,17,67,17&
228,167,285,167,299,168,309,176,314,194,308,213,290,228,267,228,169,228,134,230,97,233,66,231,43,223,27,206,22,184,24,156,29,128,25,103,17,78,20,54,34,41,51,35,67,37,81,44,91,61,81,84,85,114,113,124,144,129,184,127,206,120,220,92,229,80,247,72,266,82,276,101,294,108,312,96,329,82,343,76,357,85,359,104,359,150,359,197,367,215,381,224,402,225,417,210,422,192,422,96,419,76,413,61,399,44,376,30,325,26,275,26,249,25,214,16,192,11,174,16,162,32,160,67,155,100,152,140,158,159,178,168
]],mspl[[
	2,2,3,3,3,3&
	3,2,1,3,1,2&
	3,3,1,2,2,1&
	1,4,2,3,3,2&
	
	3,4,3,1,1,3&
	1,2,2,4,4,4&
	4,1,2,3,4,1&
	2,1,4,3,2,4
]],mspl[[
	0,2,3,4&
	0,3,3,4&
	2,1,6,4&
	0,2,1,1&
	
	5,6,3,4&
	0,5,2,1&
	0,2,6,4&
	5,6,6,3
]],split[[
.13,.15,.18,.21,
.012,.016,.02,.024,
.95,.93,.9,.85,
.6,.75,.85,.92,
20,12,8,6,
9,12,16,20,
]],split[[
.15,1.75,6,
.15,1.2,16,
.1,1,5,
.5,2,4,
.1,2,1,
.15,1.75,4,
.15,1.2,4,
.1,1.5,4,
]],split"accel,steer,brake,cross,fight,armor",split
[[ fireant
, caramelo
, lemo-8
, rodyle
, dolphish
, g. sigan 
, dark matt
, tb-system
]],split
([[colony worker
#848740241648,
and its only
licensed pilot
;wants to make
his owner
proud
;former racer.
her mind was
merged with
the ship's
system
;wants to
destroy ships
and maybe win
the race in
the process
;ocean planet's
#1 bodybuilder
and best paid
pilot
;special forces
tank expert.
very proud of
his facial
hair
;4d being.
very shy,
only appears
in special
occasions
;ultra-advanced
a.i. with an
old school
hardware
design
]],";"),mspl[[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2&
1,2,3,2,5,5,15,12,4,9,11,12,13,1,5,0&
1,1,3,5,5,5,7,11,13,6,11,12,13,1,3,0&
1,2,3,4,5,6,7,8,9,10,11,12,13,1,2,0]]
-->8
-- menu

function _init()
 music"0"
 
 ents,scores,eclr,hh,s,st,t,fd,race_count,rc1,mode={},{},split"0x1.5,0x11,0x1d,0xdd,0xd6,0x66,0x66,0x67,0x67",split"-10,-10,-10,-10,5,9,12,14,16,17,18,20,21,22,23,24,24,25,26,27,27,28,28,29,29,29,30,30,30,30,31,31,31,31,31,31,31,31,31,31,31,31","2222233299192222229999929911921122329192922232929232919292223292222223299199222329999929111999212232912922233299223291292223329922222329192222232999992911919921223299922223321992329992222332192222232912222233299999299919992122322929223339992232292922333999222223299222223321999992999992112223229222332192922322922233219222222322222223339999999229992211222232223332119922223222333211992222223222222332192999999222111122222333332119929222233333211992222222232223332119999999999911112222222222119929222222222211992933292222333332119999999999911111222222991199929292229299119992232222922922222119929292999991119932222229292333292922292999292232922329222991199929222929991119112322222292322222929222229292232929232922229292233332229999111911232292222329922329222922292223299223212222292233333322299911191123222922232929232992222222222322223299229222233222222292991111993222222223229223212922292222222233291922292233299192222999111111222292922222223299922222222222232291922292223299199222329911111122222922222333291929222222222922991929222922329192222232991111112222222229222291929222222222229292929222222232912222233299111111233332222292991929233332222222222223332922223299222223321911111133333322222292929233333322222222223222229222322222223339991111193222222222222929223222222222222223299223292223222222332199111199299192222222222233299192222222222329292329222232223332119911119199199222329222223299199922329222232292232122922333332119991111919192922232929222329192922232929222222232992229222222119999911191912922233299222232912922233299222223332919222292991199999991119199922223321992223299922223321992292222919222292929299999991111912929223339992222322929223339992222929919292222229299999999111119229222332192922223229222332192922222929292222222299999222211111132223332119922222232223332119922222229292222222222999299992111112333332119929222922333332119929222222222222333292299299119921111922222119929222222222222119929222222222222322222929929119992111122991192923333222922991199922222333292222329922329992919999211112929292923333332222222222222222222222922232929232999299999921111222292923322222222292222222222239922329223229223219992999921111122222223329919222292222222222232929232922222223299999922221111112222222329919922232922222222223229223212222333291999999999111111222922232919292223292922222222322223299229222291929999991111992222922223291292223329922333292222333291922292991929299999911229993222922329992222332199322222922222291922222292929292999999321111222222232292922333999329922329922991929222222929222929999221111122222222322922233219232929232929292929222222333333229999931111112223292223222333211993229223212222929222222332222222299993111111222329929233333211992922223299222222222292332991922222999211111122332929292222211992922333291922222222222232991992223299921111112233219292299119992929222291929222222229223291922222329992111111233399292222929292922292991929222222222292329122222332999921111123321992222229292222222292929222333322222232992222233219991211193321192222222222233329222929222233333229223222222233399999119999321192233329222232222292222222232222222222232222223321999991111121199232222292232992232922222233991922222222322233321199999111111999232992232923292923292222233291992223292223333321199999911111929223292923292322922321222223291922222329222222221199999991999929292322922321222222329922222329122222332992229911999999999211113222222222329922233329192222232992222233212922233329999999921111329222233329192922229192222223292222233399922232222299999992111132292922229192229299192922222322222223321929232992232999999211113292229299192922229292922222223222233321199223292923299999119999292222229292922222292922222222233333321199292322922321999991111192922222292922222222222222222222222221199292222222329999999111112922222222222222222222222222222229911999292222233329199999991111222223333222222222222333322222229299929292222922229199999999111122223333332222222222333333222222292929223333229299199999999911112223322222222222222332222222222222929223333332229292999992229111223329919222222222332991922222222222223322222222292999992999221122329919922232922232991992223292","00000333330333331003333333330033333333300333300033330333333333000033333330013333333333003333333330400000000000000000000000000000000003333303333310033333333300333333333103333300333303333333333000333333300133333333330133333333300404040000000000000000000000000000333333333333100333333333103333333331033333003333033331233330003333333301333333333301133333333340404440400000000000000000000000003333333333331033331133331033311333310333333033330333311333300033323333011333322222011333331111040445440404000000000000000000000333333333333110333311333113333113333103333333333303333113333000333113330113333222220113333333330040445444404000000000000000000003333133233331103331133331133331133331033333333333033333333330003333333301133332222101133333333330040445454444040004000000000000333331221333311333311333311333110333113333313333330333333333300333333333311333330000001133333333300000445465444040000000000000003333112213333113333103333113331033331133331133333303333333331003333333333013333300000011333331111400000404566544440400000000000333331100333331133311033311333310333311333311133333033331133330033331133330133333000000113333333333000000404566545440404000000003333310003333313333333333113333333333113333111333330333311333330333311333331133333333330133333333333004000404456545444404000000333331100033333133333333331133333333331033331111333303333113333303333111333311333333333301133333333330000040404454545454444040003333311000333331333333333311333333333310333310113333033330113333033331113333113333333333011333333333330000000404444444440404040022222100002222212222222222112222222222102222001122220222201122220222200122221122222222220012222222222200000000004040404040004004022221000022222022222222221022222222221022220001222202222001222202222001222201222222222200122222222222000000004000040000000000000222200000222220122222222210122222222210222200012222022220002222022220002222012222222221001222222222210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",un_sp"0,8,0,1,0"
 fad(0)
 for i=1,8 do
  local p={
   id=i-1,
   len=0,
   pos=0,
   frags=0,
   death=0,
   score=0,
  }
  add(scores,p)  
 end
 local ready
	for i=0,4095 do
	 sset(i\64+64,i%64+64,tonum(sub(s,i+1,i+1))+4)
	 sset(i%128,i\128,tonum(sub(st,i+1,i+1)))
	end

 local sel,stp=0,0
 local e=mke()
 e.upd=function()
  if btnp"5" then
   if ready then
    mfunc"sfx,0,-1,1,4"
    stp+=1    
    if stp==3 then
     race_count=sel 
     rc1,scr_pal=race_count+1    
    elseif stp==2 then
     mode=sel
     if mode==0 then stp+=1 end
    end
    if stp==3 then
     stp,e.upd=0
     fade_to(goto_sel)
    end    
   end   
  else
   ready=true
  end
  local inc=function(n)    
    sel+=n
    sel%=3
    mfunc"sfx,6,-1,1,1"
  end
  if btnp"2" then inc(-1)
  elseif btnp"3" then inc(1)
  elseif btnp"4" then
   stp=max(stp-1,0)
   mfunc"sfx,0,-1,5,2"
  end

 end
 
	e.dr=function()
	mfunc"cls,palt,0b0111000000000000"
 pal(split"1,2,3,1,2,13,7,8,9,10,11,12,13,14,15,0")
	spr(12,(500+t)\16%160-32,un_sp"40,4,2")
  	
	
	
	--stars
	starfield"80"	
	
	--earth
 scr_pal=split"1,2,12,140,5,6,7,8,9,10,11,12,13,14,15,0"
 mfunc"fillp,0xa5a5,line,0,106,178,80,1.3125,line,0,107,177,81,1.3125,line,0,108,176,82,17,line,0,109,175,83,17,line,0,110,174,84,0x14,line,0,111,173,85,0x14,line,0,112,172,86,0x44,line,0,113,171,87,0x44,line,0,114,170,88,0x43,line,0,115,169,89,0x43,line,0,116,168,90,0x33,line,0,117,167,91,0x33,line,0,118,166,92,0x33,line,0,119,165,93,0x36,line,0,120,164,94,0x36,line,0,121,163,95,0x37,line,0,122,162,96,0x37,line,0,123,161,97,0x37,line,0,124,160,98,119,line,0,125,159,99,119,line,0,126,158,100,119,line,0,127,157,101,119,line,0,128,156,102,119,line,0,129,155,103,119,line,0,130,154,104,119,line,0,131,153,105,119,line,0,132,152,106,119,line,0,133,151,107,119,line,0,134,150,108,119,line,0,135,149,109,119,line,0,136,148,110,119,line,0,137,147,111,119,line,0,138,146,112,119,rectfill,64,114,127,127,fillp,rectfill,0,127,127,127,7,pal"
	
	
	local tt=t/90
	function satel(c)
	 local r=(sin(tt-.25)*4+8)
	 for i=0,1 do
	  local rr=r*(1-i/5)
		 circfill(sin(tt)*50+60+rr/2,sin(tt)*-10+78+rr/2,rr,split"8,2,1,0"[5-i-r\3.5])
		end
	end
	
 satel"2"
	
	--moon
 local xx=t/10
	for i=-31,31 do
	 local hgt=hh[40-abs(i+6)]
	 for j=-31,31 do
	  if j==hgt-20 then
	   mfunc"pal,6,13"
	  end
	  if j==hgt-16 then
	   pal(7,6)
	  end
		 if j==hgt-12 then
	   pal(13,5)
		 end
	  if j==hgt-8 then
		  pal(5,1)
	  end
		 s=(i*i+j*j)/1444
			if s<.7 then
			 local ss,px,py=s*s-.51,i+xx,j
				pset(i+63,j+78,
				sget(
				flr(px+i*ss)%64+64,
				flr(py+j*ss)%64+64
				)
				)
			end
		end
		pal()
 end
	
	if (tt+.25)%1<.5 then
	 satel"8"
	end	
	--title text
	mfunc"pal,3,13,palt,0b1000110000000000,spr,0,14,20,13,2"


 -- menu
 if stp>0 then
  mfunc"rectfill,32,96,96,124,0"
		local a=split"tournament,single race,pratice,aristarchus,mare nectaris,orbital path"
  for i=0,2 do
   local s=a[i+stp*3-2]
   if not s then
    ?stp,un_sp"0,0,7"
   end   
   ?s,64-#s*2,100+i*8,sel==i and 7 or 13
  end
 end
 end
end

function goto_sel()
 music"14"
 cmx,cmy,windows,pool,mute_win=0,0,{},{}
 add_window"0"


 for i=0,7 do add(pool,i) end

 local chk,ready=true,{}
 for i=1,7 do add(ready,i) end
 
 -- loop
 local f=function()
  for k in all(ready) do
   if btnp(❎,k) then
    add_window(k)
    del(ready,k)
   end  
  end
  local go=chk
  for w in all(windows) do
   go=go and w.ready
  end
  if go then
		 for w in all(windows) do
		  scores[w.sel+1].hum=w.pid
		 end 
		 chk=false
		 wt(16,fade_to,init_game)
  end
 end
 loop(f)
end
-->8
-- tools
function gside(ax,ay,bx,by,x,y)
 return sgn((bx-ax)*(y-ay)-(by-ay)*(x-ax))
end

function mfunc(s)
 local s,i1,i2,arg=split(s),1,1,{}
 while i2<=#s do
  i2+=1
  if _ENV[s[i2]]~=nil
  or i2>#s
  then
   _ENV[s[i1]](unpack(arg))
   i1,arg=i2,{}
  else
   add(arg,s[i2])
  end
 end
end


-->8
-- add_window
function shift(a)
 return del(a,a[1])
end

function add_window(pid)
 local wn={
  pid=pid,
  sel=0,
  sstat=split"0,0,0,0,0",
 }
 wn.sstat[0]=0

 add(windows,wn)
 solo=#windows==1
 if not solo then
  mfunc"memset,0x5f70,0,15"
 end
 
 wd=split"0,0,128,128,0,0,64,128,64,0,64,128,0,0,64,64,64,0,64,64,0,64,128,64,0,0,64,64,64,0,64,64,0,64,64,64,64,64,64,64,0,0,64,42,64,0,64,42,0,42,64,42,64,42,64,42,0,84,128,42,0,0,64,42,64,0,64,42,0,42,64,42,64,42,64,42,0,84,64,42,64,84,64,42,0,0,64,42,64,0,64,42,0,42,64,42,64,42,64,42,0,84,42,42,42,84,42,42,84,84,42,42,0,0,42,42,42,0,42,42,84,0,42,42,0,42,42,42,84,42,42,42,0,84,42,42,42,84,42,42,84,84,42,42"
 local bi=-1
 for i=1,#windows-1 do
  bi+=i
 end 
 for i,w in ipairs(windows) do
  local id=(bi+i)*4  
  w.x,w.y,w.ww,w.hh=wd[id+1],wd[id+2],wd[id+3],wd[id+4]
 end
 
 -- selector  
 local sl=mke()
 sl.dc,scr_pal=0
 sl.upd=function()  
  sl.dc*=.75  
  local inc=function(n)
   if #pool>0 then 
    wn.sel=(wn.sel+n)%#pool  
    sl.dc+=n
    mfunc"sfx,6,-1,1,1"
   end
  end
  if not wn.ready then
	  if btnp(1,wn.pid) or btnp(🅾️,wn.pid) then 
	   inc(1)
	  elseif btnp(0,wn.pid) then 
	   inc(-1) 
	  elseif btnp(❎,wn.pid) and sl.t>24 then
	   wn.sel,wn.ready=pool[1+wn.sel],true
	   del(pool,wn.sel)
	   mfunc"sfx,7,-1,2,9"
	  end
	 end
 end 
 
 sl.dr=function()
  function sel_typ(k)
   return wn.ready and wn.sel or pool[(wn.sel+k)%#pool+1]
  end
  
  if win!=wn then
   return
  end
 
  camera(-win.x,-win.y)
  rectfill(0,0,win.ww,win.hh,1)
 
  pal()
  for i=1,8 do
   fillp(split"0,0x1000,0x1040,0x1414,0x5a5a,0xbebe,0xfefb,0xfeff,0xffff"[i])
   rectfill(0,i*3-3,127,i*3,0x10)
  end
  fillp() 
  
  local hcol=win.sel
  local cl,mdx,mdy,km=8+hcol,win.ww/2,#windows<=2 and 36 or win.hh/2,wn.ready and 0 or #pool
	  
  -- ships
  for k=-km,km do
	  for i=0,1 do
	   hi=sel_typ(k)
	   local cl=8+hi%8
	   pal(8,cl)
	   pal(2,sget(8+cl,1))
	   if i==0 then
	    apal(k==0 and cl or 0)    
	   end
    local x,y=mdx+(k+sl.dc)*24-4,mdy-i*(8.5+cos(t/24)*2)
	   y+=cos((x-mdx)/128)*16-12    
    local fr=128+hi*16
    if not wn.ready then
    	fr+=t/2%16
    end
    spr(fr,x,y)
    pal()
   
	  end
  end  
  
  --
  if #windows<=2 then
	  s=mfunc"rectfill,0,53,127,127,5,rectfill,0,53,127,53,13,rectfill,0,90,127,127,6,rectfill,1,56,2,126,13,rectfill,3,57,3,125,13,rectfill,127,55,127,127,13,rectfill,126,56,125,126,13,rectfill,124,57,124,125,13,line,1,55,3,57,1,line,126,55,124,57,1,rectfill,4,58,123,125,0"

	  for i=0,1 do
		  if solo then
		   ?ship_names[hcol+1],23,68-i,13-i*6
		  end
		  ?s_desc[hcol+1],65,69-i,1+i*12
		 end
	  
	  local xx,yy
	  if solo then
    --mugshot
	   spr(72+hcol%4*2+hcol\4*32,7,62,2,2)
		  mfunc"poke,0x5f5f,0x10,poke,0x5f77,0xc0,memset,0x5f78,0xff,2"	  
	   pal(mspl"1,2,130,136,5,6,7,8,142,10,128,129,13,141,15,0&1,132,129,4,5,6,7,137,9,10,11,12,13,14,15,0&1,129,3,130,5,6,7,8,138,10,11,12,13,133,135,0&1,2,3,131,5,6,7,129,9,10,11,130,13,139,4,0&1,130,133,4,5,6,7,2,141,128,140,12,13,14,15,0&1,129,128,4,5,6,7,130,141,132,133,142,13,143,15,0&1,130,3,141,5,6,7,8,9,10,142,143,13,14,15,0&1,2,141,4,5,6,7,134,9,129,133,142,13,143,15,0"[hcol+1],2)
	   
	   --medals
	   for o=0,2 do
	   for i=1,4 do
     local lvl=dget(hcol*4+i-1)
     pal(pp[lvl+1])
     if o<2 then
      apal(o)
     end
	    spr(i==4 and 39 or 18,68+i*11-o,46,i\4+1,2)
	    pal()
	   end
	   end
	  else
	   xx,yy=camera(-win.x+60,-win.y+43)
	  end
	  for i=1,4 do
		  if i<=2 then
		   ?"weapons",80,106-i,19-i*6
		  end
    rect(55+i*13,112,66+i*13,123,1)
    spr(112+sweap[hcol+1][i],57+i*13,114)
	  end
	  camera(xx,yy)

	  --stats
	  for i=0,5 do
	   local y=84+i*7
	   ?caracs[i+1],7,y,7
	   local n=ships[1+hcol][1+i]
	   wn.sstat[i]=(wn.sstat[i]+n)/2
	   if (wn.sstat[i]%1>.95) wn.sstat[i]=ceil(wn.sstat[i])
	   sspr(119+n/1,10,1,5,28,y,wn.sstat[i]*8,5)
	  end
	
		end
		--if not solo then
  	-- name
  	local s=sel_typ"0"
	  local sn=solo and "" or ship_names[s+1]
	  if wn.ready then
	   sn=t42 and"" or "ready"
	  end	  
	  ?sn,mdx-#sn*2,4,s+8
  --end
 end
end
-->8

menuitem(1,"double control",
function()
 obtn,obtnp,km=btn,btnp,mspl[[4,7,7,7,4,5&0,7,7,7,0,1]]
 local function b(k,p)
  p=p or 0
  return km[p\4+1][k+1],p%4
 end
 btnp=function(k,p)
  return obtnp(b(k,p))
 end
 btn=function(k,p)
  return obtn(b(k,p))
 end
 menuitem(1)
end
)



function map_pal(m)
 if m==3 then
  mfunc"palt,6,true"
  pal(split"8,14,3,4,5,0,7,8,6,7,11,12,13,1,15,0")
  for i=1,4 do
   pal(split"15,11,4,3"[i],split"9,7,10,15"[(i-t\1.5)%4+1])
  end
 else
  mfunc"pal,14,1"
 end
end
__gfx__
228899a71123456789abcdef7777777751515151777777007770000000000000000000000007070007070700070707000707000007000000000000002888eff7
8ba9ce00111121d62493d5de7ddddddd151515157777770078700000000000000000700000707000707070707070707070000070000000700000007049999ff7
2493d5de1111115d1241515d7d515151555151517777770078700000000700000707070007070700070707070007070000070000000700000000000049aaaaa7
ddccbba711111115112111157d15151515151555777777007870000000707000007070007070707070707070707000707000007070000070700000003bbbbaa7
228899a711111111111111117d51515151515151777777007770000000070000070707000707070007070707070707070707070000070000000000001cccc667
cccccc7711111111111111117d1515151555151577777700000000000000000000700000007070007000707070007070000000000000000000000000222ddee7
000000001151d517c9f11111766666665151515577777000000000000000000000000000070700000707070007070700070707000700070000000700eeeeeff7
9aba00001131d517b6711111655555551515151577770000000000000000000000000000000000000070707000700070000000000000000000000000effff777
aa5555555555555508ffff80aa11119a5555555555555555555555aaaa555555aa11119a5555ee77aa11119ad55dd55d777777765555555555555555228899a7
925555555555555588efff88aa91112a55555555555555555555555aa5555555aa91112a5555ee77aa91112a55dd55dd7666666d55555e55555555e5ccbbbba7
1155555555555555880000885555555555555555555555555555555555555555555577ee555577ee5dd55dd55dd55dd57666666d555ee55555555e558abc49a7
1155555555555555880000885555555555555555555555555555555555555555555577ee555577eedd55dd55dd55dd5576d55d6d555d5d55555ee5558abc5d67
11555555555555558880088855555555555555555555555555555555555555555555ee775555ee77d55dd55dd55dd55d7666666d55d5555ee5e555558abc249f
195555555555555508800f8055555555555555555555555555555555555555555555ee775555ee7755dd55dd55dd55dd76d55d6d55d5555555e55555493d0000
aa555555a21119aa0888fff055555555a55555555555555a5555555555555555555577eea21119aa5dd55dd5a21119aa7666666d555555e55555555524510000
aa555555a91111aa00888f0055555555aa555555555555aa5555555555555555555577eea91111aadd55dd55a91111aa6ddddddd555ee555555555559aba0000
6666666600000000007aaa00555555aa00000000000000000670000000000a99aaa0000077777776000000000ddddddddddddddd777777760800000000080000
666666660068600007244aa0555555aa000000000088800067d0000000007221242a00007ddddd6dd000000000dddddddddddddd7666666d0080008000000008
66666666068886007249aaa95555559100777000088888007dd00000000721114422a0007d66666ddd000000000ddddddddddddd7667f66d0000008888000080
6666666606282610a49aaa795555551100777000088888006d000000000aa212442aa0007d66666dddd000000000dddddddddddd76711d6d008808f8888f8000
6666666606626610a4aaaa7955555511007770000888880000000000000a9a7aa99a40007d66666ddddd000000000ddddddddddd76f15d5d000888fff8888000
666666660d666d10aaaaa7a955555511000000000088800000000000097a9aa9994942407d66666dddddd000000000dddddddddd766dd55508888fff8ff80808
6666666600ddd1100aa77a9055555529000000000000000000000000070a4aa9992940907666666ddddddd000000000ddddddddd7666555508f8ffffffff8800
666666660001110000999900555555aa0000000000000000000000000a0049a9942900906dddddddddddddd000000000dddddddd6dddd55d00888fffff8f8880
55555555666666666aa5555555555996666666665555ee77d55dd55d0a0094999444004007777660077777700777777007700770555555550008ffffffff8880
555555556666666a66a2555555551166966666665555ee7755dd55dd0099099992404900077776600777777007777770077007705e55555500888ffffff80808
55555555666666aa666215555551166691666666555577ee5dd55dd500004029920200000001166007700000077007700770077055555e5500f888ffffff8000
5555555566666225666611555511666651166666555577eedd55dd55000aa00240044000022776200770000007700770077007705555555580088f8ff8f88800
55555555666611556666611552266666551166665555ee77d55dd55d000000042000000002277620077077700770077007700770555e555e00088888888f8008
555555556661155566666619aa666666555126665555ee7755dd55dd00000049440000000221144007700770077007700000000055555555008f888f80888800
555555556611555566666669a666666655552a66555577ee5dd55dd5000009a7999000000777777007777770077777700770077055555e550088080000008800
5555555569955555666666666666666655555aa6555577eedd55dd55000000794200000007777770077777700777777007700770e5e555558000000000000080
6666666676666666666666666666666666666666666666666666666666666666bbbbbbbbbbbbbbbb333333333333333344444404444044428888888888888888
6667677777766666651dd6666666666666666666666666666666666666666666bbbb2488888442bb33333983333333334444ffaa9a044404887aa888888a9888
66777777676676661ddd6d666665d66666666666676667666666666676666666bb2488888888882b3333988333399888444afaa9a667024443a1aa88889a1888
67777611166766665d66d67666d6666666666666667676766666666666666666b48999888888884b33339f9998984248449aaaa776d67440bea1a9ebbbbee488
767711115d6666d6d666667d666667666666666767777777766766666666156628999887004608823339f999988424484469aa7777667002eeee99b1bbbbb8e8
67711115ddd66d6d6666677d66667666666676767777777677666666666dd676888888800c8cc48433349999948844834020000110007200433eeeeebbbbbe38
776111dd6d671dd6667777d666666666666667777767676766767666666667668888888ccc48888433354994d088883340200001102060041666d43eeeeee348
77d11dd6667715d66666dd66666666666666777776111111676666666666666688888888888883343380999800488333402f000ffa20d444c6777614433341d8
67615d6d677115d67677766666666666666767771111115d566666666666666648838843882343423399998888888333402a000ffa20d040cc777726777d1d68
7666d66677111dd66711d6666666666666667776111115ddd6d666666666666632323832343234233310088888884333402000011020d202c16771c2776888d8
6766677761115d667115d6d666666666666777711111dddd666d666666666666332423242324223b3300088822882333445d6ddd5ee56200c18681cc26c88888
666d6dd11115d6d6715d665d666656666667776111dddd66675dd66666677666b2444244222223cb3348888288824513444e55e422e62004318881ac22c88888
6666d5d5115d666675d66715666d6766676677d111dd6d6d671dd66666676d66bb32222cccccc33b33348888422244d5444d6ddd5e5200443c71c77a22c78888
66d66d5d6dd666666657711d66667666666776d11dd6d6666715dd666666d666bbbcccc3333222843333332222246d664444000000002224e277caa9f276d338
666666d6d666d66666d5115d66666666666776d11ddd66666711d66666666666bbbbb3322222348833331dd677665d6644200222000021113ed62f9f926d3e34
6666666666666666666dddd666666666667677615dd666667115dd6666666666bbb3b3244442234833316ddd6665dddd4200002222000211433eeeee3333ee31
00000000f3344bbff33444330004000066667666ddd6d6667111d666666666667bb7bbb1d6dddd551d66dddd911111117777feeeeeeff777fd8888888888888f
000000003344bbff3344b443000300006667676666d6666711156d6666d666667bb7b13373d3d5551ddddddddd91111177ffe444444eef778f888888888887fe
00000000344bbff3344bbb44004240006666766667777711115d666666666666b7735dd7d7dd5355119dddd9999911117ffe42000024eef7587777777777fe55
0000000044bbff3344bbfbb4432123406666666d6511111115d6666666666666bb3d77cc7cddd5d3103d5300b99b81117fe4000000004eff55888888888e5551
000000004bbff3344bbfffbb004240006666666666d511115d66d66666666666b3d777cccccddd1d03553300003b8111ff42000000002eef558844422885551b
0000000044bbff33bbff3ffb0003000066666666d66d55ddd666666666667666b5c77cccdcc2ddd115d5300003a43111fe200000000024ef558477f4228551b5
00000000344bbff3bff333ff000400006666666666ddddd6d6d6666666666d661dccccccc2dd2ddd11aa4c4aaa4ec111fe2007e0000002eeb58e77fc4285555a
000000003344bbffff33433f000000006666666666666d6d666666666666666630cccc50cc9dd2dd11222e4222ee4111e4000ff000f402eea58cfc3222855aab
000008e800000000000000000000d6d5000007cc0000bbb0000006c07777777680cccc00ec9dd2d6114c4ffffffe1111e400000000ee024e558cc2113285a5b1
000068880008800000000070000d6d510007cccc000ba7ab000c77c0dddddd653dcccccccc2ddd6d11a44ffffffc3111440000000000024ea58cc3234285aa1b
00067682068e8850000006000949f515007cc66c00ba777b0c777c10515151651dfeeccccd2ddddd103a4cccff048311420000000000024e5588ccc42885a5b1
0e676d50678884d50070d000409aaf5d07cc676c003a77abc677777c15151565b3e22eccd2dd5ddd11333333304ab8b1400000000000004ea58888888885aa1b
8878d500662442d50705007000a77f900cc676cc03b7aab0000c676151515165b15eeedddd553ddd10030303000bb3bb20000000000000245581aaaaa185a5b1
9f8d5000d6622d51a0000f000977f9007cc6ccdd0b7a3b00000c7c1015151565bba3dd55555aa15d8b0aceec0ab83b9b0000000bcb000024b58186768585aa15
a7f420005d666d15000090000aa90090ccccccdd3a3000000017c00066666665bba1a33333555a15b93baaaa3883b9d900000bcf7c0000021581aaaaa185a55b
7a94000005ddd55000040000a9000400ccdccdddb000000000cc000055555555ba133aa3333335a19993b88bbb8b99dd0000bc777fb00000a181867685855b11
7887000000000000000007d00000706000706000070600000d700000000000000000788700000870007870000770000070000060000007600007870007800000
078877007887777700077d0d0007606000706000070d6000d0d770007777788700778870000788700078700008770066877d6620770076200007860007887000
0778877777887600777770d60077d66007706600076d66007d0777770067887d777887700078870000787d000886d628887d6220887d622000d6260000788700
0dddd0000762ddd68888d6600782d660078d2600077d2260077d88826ddd26d0000dddd00772dd000778d6660722d220788d2260082d2260776d266000dd2770
0662266600dd2660777d2660088d2260788d22600782d2200778d76d0662dd006662266076dd2660077d2222076d2260078d26000722d6608822d6600762ddd7
062266000062260000d62600887d6220887d62200886d62200787d000062260000662260006622667d066666076d6600077066000076d660766660d676226600
62260000062260000006260077006620877d66200877006600786000000622600000622666666226d0d66000070d6000007060000007606000066d0d62266666
0000000006200000000626000000066070000060077000000072d0000000026000000000000000000d600000070600000070600000007060000006d000000000
7d77000000000000000068660000860000060000007800007787000000000000000077d70000d700007d70000770000070000060000007700007d700007d0000
07d777007d7778800667866200078620008620000878600087787660088777d600777d700007d700067d80000d780000d78626d0000087d00008d760007d7000
0888888077888666777876260078626007862600078726007866266677788866088888800077880006787600078662667d8d2d60778778600077876000887600
06d66666086d6222dd876266077862600786260007862660772662dd8887d68066666d600788d6000787d266078d2ddd77862660ddd8d260778d7260007d8260
0222222000622660787d2666dd8dd66077862660077dd2dd7662d62606622600022222208866d22068762ddd078626600786260007626260ddd86626088d6622
06d66600002d66000062d66077862d607d8d2d6007d86266066d26000066d20000666d6066226d66866266660862660007862600006626207776266277d62266
6d660000006d60000006d660000026d0d78626d00d680000066d60000006d600000066d6026666d666266660086260000086200000062620066662667d666620
00000000006d00000006d600000006607000006006600000006d60000000d6000000000000000000626660000062000000060000000026000006662600000000
d7780000008888000000880000088880008880000888200000880000008882000000877d0000dd00000d00000d0000000d00000d000000d00000d00000dd0000
0d777800d77776800087768000877d68087d620087d76200087772000877776d008777d000087d00007d000007d0000007d000d600000d600000d60000d78000
00d776800d77dd2007777d620277d662077d6600877d662087d7766008dd76d008677d0000877d0008760000877ddddd077ddd66ddddd7620000768000d76800
00dddd8000dd6620dd66d662d776d662877d6620276d666d877d66dd0877dd0008dddd0008777d000776d000877d666d0877d662d777d662000d766000d76620
00d6662000d66620000d6660ddddd66277ddd660266ddddd0776d00002766d0002666d00087ddd00877d66dd87d666200077d66008676d62dd77d66200ddd620
0d66620000d662000000662000000d606d000d6006d000000266000000266d00002666d008d766d086d6666087d662000086d62000866d6206666d620d766d20
d662000000d620000000d600000000d0d00000d00d000000006d000000026d000000266d0266666d0266620008222000000882000002222000866620d7666620
0000000000dd00000000d000000000000000000000000000000d00000000dd000000000000222200002200000000000000000000000000000000220000222200
60070000000600000000000800000800000800000080000080000000000060000000700600000060006800000687000006870626000062d00008d00006000000
88778000606780000077888200000800000800000080000028887700000876060008778800060880000860000087862600878620687862000007800008806000
7777780088777888d0077d2000088800008820000088200008d7700d8887778800877777000777700707d8000677862000778660087866d0008d706007777000
088dd888777dd8002877d6200677d620087d6200087d66d0087d6622008dd777888dd8800027788007778d62677d66000777d6660077d66d07d8776008877800
666662000886620006d866600077d66d777d6660777d660007762d600026688000266666008dd666087d662d087d66d00087d6200677d6208877d620666dd800
2266200006666000008d6060087866d007786600067686200706d20000066660000266228886662208d66000008820000008820000088200d0076d2022666222
600600000220d0000006200068786800087862000086862600026000000d02200000600600026d0d0822660000800000000080000000020000662222d0d62000
00000000060000000002d000000068d06870626006860000000d200000000060000000000000d0008200000000800000000080000000020000000002000d0000
87700000000000000000000800000800000800000080000080000000000000000000077800000d80000800000800000080000020000000800000800008d00000
087760008777000000067772000d7600000700000076d000277760000000776800067780000d780000780000078000027880226080000870000087000087d000
087776000877766807777d6000d7d6000067d000007d6d0007d77660877776800067778000d77800007780000777022d777d6660d88077600008760000877d00
00ddd778006ddd608877d6600d76d600067d6d00007d66d0077d662206ddd600877ddd000d77d0000677d2000777d660077d6600077d7660008d7660000d66d0
02666d00000666d0008d66d0077d6660077d66000777d6600676d2000d66600000d6662007dd6600077d6622007d66d0067d6d000d76d6008877d6600077dd60
0266d00000266d0000026600d2206660777d66600766022d0066200000d66200000d66208666662007d66660007d6d000066d00000d6d60007666d6008766662
266000000026d0000000260020000860788022600680000200620000000d620000000662000666620666d0000076d00000060000000d6600000d666087666000
0000000002d00000000020000000008080000020080000000002000000000d200000000000000000820000000080000000080000000002000000002200000000
7777d70000677d70000d68600007862000872000087260000787d00007d77600007d777700000770000700000700000070000060000000600000700007700000
0d777d707777888807778d6200dd8d26078d260078d2dd0087d877608888766607d777d000077d000077d00007d000067d000d6070000d60000d760000d77000
008888880d8866d6777876260078726d7d872d60d7872600787726667d7722d0888822000d7788000778760067872dd6778786607dd8786d0077866000887760
007766d6007722227787626d07787266d78726d077872660d7866266888266007d7766007d887600d787726d778726607787266007787866d787726d007788d6
00222222002266d6d876266d078762667786266077866260d762662d7d6622002222220088776600d876266678726660d78626d0077686267778662d00777622
0d666d6000d666d0006266607d86626d77862660678662d6066626000d666d0006d666d07d2222d08d626666d86266007d862d600066262d777626d20d8822d6
6666d60000d66000000d660060000d607d000d6006d000060066d00000066d00006d666622666666662dd66062d2dd00072d260000dd2d26066dd26666666622
00000000066000000000600000000060600000600600000000060000000006600000000006d66d00026660000262600000262000000626200006662000d66d60
87600000000006800000d800000800000800080000008000008d0000086000000000067800000680000780000800000080000020000000800008d00008600000
087676788767770000067d0000070008070006008000600000d76000007776788767678000076780006780000780002278d0d2608800086000087d0008767000
0d76770008767d000677700200d76d76067d6d0067d76d00800777d000d76780007767d000676700007d65000677566d677566d067d5d6d00057dd0000767600
005d5d00006d560077d6566d077757600775660007756660d7756d6d0075d60000d5d5008775d5000676d622076dddd0066ddd000666dd60887d76d0005d5662
0d6d6600005d6668886d66d0066ddd60066ddd00076dddd00d76d6228666d5000066d6d000d5dd00d7756d6d07756660077566000777566077d7566d00dd5d00
026d6d62006d6d000056dd00d7d5d6d0677566d00676566d006d650000d6dd0026d6d6200066d6208d066dd067d76d00067d6d0000d66d6d06666002086d6600
26d00000026d600000026d002200026078d0d2600780002200d620000006d62000000d6200666d620006d00080006000070006000006000200066d0086d66600
0000000002d000000002d000000000208000002008000000000d200000000d200000000002d00000002d00000000800008000200000200000000d20000000d20
88867600000676800007680000087600080002000077800000867000086760000067688800008880000820000800000080666080000000800002200008880000
0777776888777770006776600066766206766d00877766000777760007777788867777700006670000876d00087776028760662080777780006722000076d000
6600d67007700d6608760d6d007dd66d676d66d0676dd60067d0678066d0d770076d006606777660067dd6d0077006628700062086700760067666d0077777d0
60000d6006000d66827000620670006d77d0d6d0770006608700072866000d6006d000068660006067d00d62670006d2670006d08d70006d27600d6d0700d6d2
6600d6600600d6d226d00d6d8670006d670006d0670006d266d00d628d600d60066d006676d00060870006227700d6d077d0d6d00d7d00668270006207000d66
066666d2066666d00d6dd6d0877006d087000620077006d20d6dd6d00d6666602d66666076d00660d6d0662067dd6600676d66d00076dd6d08760d6d0670066d
222ddd00006dd00000d6220080766d208760662002766d0200226d00000dd60000ddd2220666662206666d008666dd0006766d0000dd6662006666d0886666d0
00000000022200000002200000000020806660200200000000022000000022200000000002d6d000002d6000006680000800020000026600000dd200000d6d20
__label__
00000000000100100000010000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000
00000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001d7d1000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000d00000000000000000000000171000000000000000000000000000000000000000001000000000000000000000000000000000000000000000
0000000000000010000000000000000000000001000000000000000000010000000000000000000000d000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001710000000000000000000017100000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000100000000000000000001d777d1000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000017100000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000ddddd0ddddd100ddddddddd00ddddddddd00dddd000dddd0ddddddddd0000ddddddd001dddddddddd00ddddddddd00000000000000000
0000000000000000000ddddd0ddddd100ddddddddd00ddddddddd10ddddd00dddd0dddddddddd000ddddddd001dddddddddd01ddddddddd00000000000000000
000000000000000000dddddddddddd100ddddddddd10ddddddddd10ddddd00dddd0dddd12dddd000dddddddd01dddddddddd011ddddddddd0000000000000000
000000000000000000dddddddddddd10dddd11dddd10ddd11dddd10dddddd0dddd0dddd11dddd000ddd2dddd011dddd22222011ddddd11110000000000000000
00000000000000000dddddddddddd110dddd11ddd11dddd11dddd10ddddddddddd0dddd11dddd000ddd11ddd011dddd22222011ddddddddd0000000000000000
00000000000000000dddd1dd2dddd110ddd11dddd11dddd11dddd10ddddddddddd0dddddddddd000dddddddd011dddd22221011dddddddddd000000000000000
0000000000000000ddddd1221dddd11dddd11dddd11ddd110ddd11ddddd1dddddd0dddddddddd00dddddddddd11ddddd00000011ddddddddd000000000000000
0000000000000000dddd11221dddd11dddd11dddd11ddd10dddd11dddd11dddddd0ddddddddd100dddddddddd01ddddd00000011ddddd1111000000000000000
000000000000000ddddd1100ddddd11ddd117ddd11dddd10dddd11dddd111ddddd0dddd11dddd00dddd11dddd01ddddd01000011dddddddddd00000000000000
000000000000000ddddd1000ddddd1dddddddddd11dddddddddd11dddd111ddddd0dddd11ddddd0dddd11ddddd11dddddddddd01ddddddddddd0000000000000
00000000000000ddddd11000ddddd1dddddddddd11dddddddddd10dddd1111dddd0dddd11ddddd0dddd111dddd11dddddddddd011dddddddddd0000000000000
00000000000000ddddd11000ddddd1dddddddddd11dddddddddd10dddd1d11dddd0dddd011dddd0dddd111dddd11dddddddddd011ddddddddddd000000000000
00000000000000222221000022222122222222221122222222221022220111222202222011222202222001222211222222222200122222222222000000000000
00000000000000022221000022222022222222221022222222221022220001222202222001222202222001222201222222222200122222222222000000000000
00000000000000022220000022222012222222221012222222221022220001222202222000222202222000222201222222222100122222222221000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000
000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000017100000000000010000
00000000000000000000000171000000000100000000000000000000000000000000001000000000000000000000000000000000000001000000000000171000
0000000000000000000001d777d10000000000000000000000000000000000000000017100000000000000000000000000000000000000000000000000010000
00000001000000000000000171000000000000000000000000000000000000000000171000000000000000000000000000000000000000000000000000000000
000000001010100000000000d0000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000
00000001010111010000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000101121101010000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010112111101000000000000000000000000001000017100000001000000000000000000000000000000000000000000000000000000000000000000
0000000000101121211110100010000000000000000000d00000100000000d000000000000000000000000000000000000000000000000000000000000000000
00000000000001121d21110100000000000000000000017100000000000017100000000000000000000000000000000000000000000000000000000000000000
000000001000001012dd211110100000000000000001d77711000000666666666666666000000000000000000000000000000000000000000000000000000000
0000000000000001012dd212110101000000000000000171000007666677666666d6d66776000000000000000000000000000000000000000000000000000000
000000000000100010112d212111101000010000000000d00076d5d6d6676dd66666666676dd6000000000000000000000000000000000000000000000000000
00000000000000010101121212121111010000000000001067d56d66677765677777666666666660000000000000000000000000000000000000000000000000
00000000000000000010111111111010101000000000000676dd666776555d766dd66666d6667667000000000000100000000000000000000000000000000000
0000000000000000000001010101010001001000000006677666777665ddd67666dd667666666667770000000000d00000000000000000000000000000100000
00000000000000000001000010000000000000000000d666667766ddddd6d6d6676667666d66666dd6500000001d7d1000000000000000000000000000000000
0000000000000000000000000000000000000000000dd666666d5dd6d6d6dd6dd666666d55ddd6d6dddd01000000d00000000000000000000000000000000000
000000000000000000000000000000000000000000d6d6666d6dd6dd666666d66ddd55d5dd66d666666667100000100000000000000100000000000000000000
00000000000000000000000100000000000000000d6d66666d6666666666666dd66d66d6d6d66766666667000000000000000000000000000000000000000000
0000000000000000000000171000000000000000d6d6666666677766666666666666dd666d666677766666700000000000000000000000000000000000000000
0000000000000000000000010000000000000005d6666667776667777666dd6666666666d667776d667666760000000000000000000000000000000000000000
00000000000000000000000000000000000000d66666667666dd6666776666d66dd666666667766ddd666d67d001000000000000000000000000000000000000
0000000000000000000000000000000000000666d666677dddddd6667766d666666666666667776dd55d6666660d000000000000000000000000000000000000
0000000000000000000000000000000000100666d66676dd55d66d667766d66666666666666777655d6dd76d6617100000000000000000000000000000000000
0000000000000000000000000000000000d0667dd6676ddd66d6d6667766ddd666666dd6666677665d6d667666677d1000000000000000000000000000000000
000000000000000000000000000000001d77666566776d5dd66d666777655dddd666666666666776dddd66666667100000000000000000000000000000000000
0000000000000000000000000000000000d6d7d6667765d6d666667776655dddd6666666666666766d666667d6d6000000000000000000000000000000000000
0000000000000000100000000000000000666ddd66765ddd6666667776655dd66dd666666666666666d66667666dd00000000000000000000000000000000000
0000000000000000d000000000000000006765666776dd666666667776655ddd6dd666666666666666666667666dd00000000000000000000000000000000000
000000000000000171000000000000000066d6666776666666777776655dd66dd66666666666666666666677656dd00000000000000000000000000000000000
00000000000001d777d100000000000006ddd6666676666666777776655dddd66666666666666666667677776d6ddd0000000000000000000000000000000000
0000000000000001710000000000000006d666666666666777777665555dddd6666666666666666666777777556d650000000000000000000000000000000000
0000000000000000d0000000000000000666666666666667777776655dddd66666666666666666666666677655ddd50000000000000000000000000000000000
000000000000000010000000000000006d66666666667777777665555dddd6666666666666666666666666d55dddddd000000000000000000000000000000000
0000000000000000000000000000000056666666666677777776655dddd66667777776666d666666666ddd555dddddd000000000000000000000000000000000
00000000000000000000000000000000d66666666666666666d5555dddd66667777776666dd6666666666d5ddddddd6000000000000000000000000000000000
00000000000000000000000000000000666666666666666666d5ddddd6666776666666666666666666666dddddddddd000000000000000000000000000000000
00000000000000000000000000000000d67776666666dddd55ddddddd666677666666666666dd6666666d6dddddddd5000000000000000000000000000000000
00000000000000000000000000000000667667666666dddd55dd6dd66dd7766dddd66667766dd6666666d6dddddd6dd000000000000000000000000000000000
0000000000000000000000000000000067ddd666666666ddddd66dd66dd7766dddd6666776666666666666ddddd6dd5000000000000000000000000000000000
0000000000000000000000000000000067d5d6766d666666666666666667766dd66dd667766dddd666666ddddddd5dd000000000000000000000000000000000
0000000000000000000000000000000067d5d6766d666666666666666667766dd66dd667766dddd66666dddddddd5dd000000000000000000000000000000000
0000000000000000000000000002222222d66676d6d66666666666666667766dd66dd667766dd66666777ddddddddd5000000000000000000000000000000000
0000000000000000000000000228888822226676d6d6666666666666666776666dd66667766dd66666777ddddddd5d5000000000000000000000000000000000
0000000000000000000000002888888888222666dd6d666666666666666776666dd6666776655dd677ddddddddddd61000000000000000000000000000000000
00000000000000000000000288888888888222765d6d66666666666666666666666667766dd55ddd77dddd6ddddd655000000000000000000000000000000000
00000000000000000000002888888888888822265dd666666666666666666666666667766d5dd6d7dddddd655dddd15000000000000000000000000000000000
00000000000000000000028888888888888882225d6d666666666666666dd6677777766dd55dddd7ddddddd55ddd15d000000000000000000000000000000000
0000000000000000000002888888888888888222566d666666666666666dd6677777766d5ddddd77ddddd6d55dd5dd0000000000000000000000000000000000
00000000000000000000288888888888888888222ddd66766666666666666dd666666dd55ddddd76ddddd651dddddd0000000000000000000000000000000000
00000000000000000000288888888888888888222ddddd777777777666666dd6666ddddddddddd66dddd6d5d5ddd5d0000000000000000000000000001010101
00000000000000000000288888888888888888222dddd77dd777777dddddddddddd55dddddddddddddddd55ddd6d500000000000000000000010101010101011
00000000000000000000288888888888888888222ddd777dddddddd77dddddddddddddddddddddddd666d5d5d6ddd00000000000000101010101010111111111
00000000000000000000288888888888888888222dd677dddddddddd7ddddddddddddddddddddddd66d51d5ddddd50000000101010101010111111111111s1s1
00000000000000000000228888888888888882222ddd66ddddddddddd77dddddddddddddddddddd5ddd55dddd5dd010101010101011111111111111s1s1s1s1s
00000000000000000000228888888888888882222ddd66ddd555dddddd6ddddddddddddddddddddd551dddd6556110101011111111111111s1s1s1s1s1ssssss
0000000000000000000002288888888888882222dddd66dd55dd5ddddddd6dddddddddddddd5ddddddddddd6dd511111111111111s1s1s1s1s1sssssssssssss
000000000000000000000222888888888882222266ddd6dd5ddddddddddd6dddddddddd5dd5ddddddddddddd6d11111111s1s1s1s1s1s1sssssssssssscscscs
0000000000000000000000222888888888222226dd6ddd6ddddddddddddd6dddddddddddddddddddd5dddd56d51s1s1s1s1s1s1sssssssssssscscscscscsccc
00000000000000000000000222288888222222d5d5dddddddd5ddddddddd66d5555dddddddddd66ddd5ddd5551s1s1s1sssssssssssscscscscscscscccccccc
0000000000000000000000002222222222222001dddd6d5ddddddddddd6666d55dd55ddd66666d6ddddddd551sssssssssssssscscscscscsccccccccccccccc
00000000000000000000000002222222222200005ddddddddddddddddd6666d5555ddd66dddd5ddd6ddd555ssssssssscscscscscscccccccccccccccccc6c6c
0000000000000000000000000002222222000001056666d5dd6dd6666666dd555ddd666d5555ddd6d5d55dssscscscscscscscccccccccccccccccc6c6c6c6c6
0000000000000000000000000000000010101010105ddd51d5dd6666666d11155dd666d5111dddd6d5555scscscscscccccccccccccccccc6c6c6c6c6c6c7c7c
000000000000000000000000010101010101011111155511dd5555dd51d111555666d5515ddddd6d5555scscccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7
000000000000000000101010101010111111111111115555555555515555555dd666d155ddddd6d1555ccccccccccccccccc6c6c6c6c6c7c7c7c7c7c7c7c7c77
0000000000010101010101011111111111111s1s1s1s15555555555555d5555dd666ddddddd661555dccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c777777777
00001010101010101111111111111111s1s1s1s1s1sssss555555d555555555ddddddddd66611555cccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c77777777777777
0101010101011111111111111s1s1s1s1s1s1sssssssssss55d55155d55555d555d5ddddd155551cc6c6c6c6c6c7c7c7c7c7c7c7c7c777777777777777777777
101011111111111111s1s1s1s1s1s1sssssssssssssscscscs1d515555d555555555555511111c6c6c6c6c7c7c7c7c7c7c7c7c77777777777777777777777777
11111111111s1s1s1s1s1s1sssssssssssssscscscscscscsccccd55555d55511111111111c6c6c7c7c7c7c7c7c7c7c777777777777777777777777777777777
1111s1s1s1s1s1s1sssssssssssssscscscscscscsccccccccccccccddd111111551111c6c7c7c7c7c7c7c7c7c77777777777777777777777777777777777777
1s1s1s1s1sssssssssssssscscscscscscscccccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c777777777777777777777777777777777777777777777
s1s1sssssssssssssscscscscscscscccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c7777777777777777777777777777777777777777777777777777
ssssssssssscscscscscscscccccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c777777777777777777777777777777777777777777777777777777777
sssscscscscscscscccccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c7777777777777777777777777777777777777777777777777777777777777777
scscscscscccccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c7c777777777777777777777777777777777777777777777777777777777777777777777
cscscccccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c7777777777777777777777777777777777777777777777777777777777777777777777777777
ccccccccccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c7c777777777777777777777777777777777777777777777777777777777777777777777777777777777
cccccccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c7c7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
ccccc6c6c6c6c6c6c7c7c7c7c7c7c7c7c77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
6c6c6c6c6c7c7c7c7c7c7c7c7c7c7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
c6c6c7c7c7c7c7c7c7c7c77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7c7c7c7c7c7c7c7c7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
c7c7c7c7c77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7c7c7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__gff__
00040001220000000000000000000000202000202020202020202828012020000000002000000020200100000001000020202020202028202000000000220000000000000000000000000000202000000000000000000000000000000000000000a0a00000000000000020200000000000000000000000010000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
40412903771c2d1c20202020202057202053202020522020432020202020204242202043202020202020202020204220522043204445462020202903771c2d292020202052202020202020311a1a1a1a1a1a1a1a1a3420202020202031131313131334202020202020202031131a1a1a1a1a1a1a1a1313131313133420202020
50513113131a1a1a1a1a1a131313131318131313131313131313131313133420203113131a1a1a1a1a1a1a1a131813131334202054555620202020203113131313131334204320202020311736363636363636363616342020202031173030303030161313342020311313173036363636363636363030301e1d3d1634202020
20201030303636363636363030303030353030303030303030303030303016343117303036363636363636363035303030163420646566202042203117303030303030163467532020311730363636363636363636301634202031173030303030303030301613131730303030363636363636363630303030301e3d16342020
47201030151b1b1b1b1b1b111111111119111111111111111111111430303023103030151b1b1b1b1b1b1b1b111911143030163420202057202031173015111111143d30163420203117303030303030303030303030302320201030303030151114303030303030303030303036363636363636363030303030301d3d163420
2020101533572020204720202020202020422020202020202029291030303023103015331c037720572020202020203214303023202020202031173015332920203214303023202010303030303030303030303030303023202010301e3015332032111114303030303030303036363636363636363030303030303030301634
20571023204445462020202d29292053202020576753202020292910301d30231030163420202020202042204041202032141d232020202031171d30232020432031173030232020103030303030303030303030303030232020103030302320202020203211111111111111111b1b1b1b1b1b1b1b1111143030303030303023
20201023205455565720202d1c2d2920311313131313131313131317303030233214301613131313131334205051202057103023202020311730301533202d67311730303023202010303030301511111114301d3030302320201030303023202020202020202020202020202020202020202020202020321430303030303023
53201023206465662020201c2d037731173030301e303030303030303030153320321430303030303030161334292020201030235320521030301533202020311730303015332020103030301533202020321430303015332020103030302320202020202020202020202020202020202020202020202020321430301d303023
202010232020205320202020291c291030303015111111111111111111113320532032111111111111143030231c20202010302320202010301533204220311730303015332020201030303023202020202010303030232020201030303023202020203113131313131334202020202031131313133420202032143030303023
20201016342020202020205320203117303015331c1c1c1c1c29292929292020674720202d291c2920103030232d20202010302320202010302353202031173030301533404120203214303023202020203117303015332020201030303023202020311730303030303016342020203117303030301634202020321430303023
2020101d23205720532020202020103030153320204220202020202020202052202020200377292d311730302329202020103023204267103023202020101d303015332050512043201030301634202020103030302320202020103030153320202010301d1e1511143030232020201030303030303016342020201030303023
2020321416342020202020404120103030232020432020404120205320202020202052203113131317303015332020202010302320204710302320432010303015332020202020202010303030232020311730301533202020201030302320202020103030153320321430163420311730301511143030232020201030303023
205220103023205220202050512010303023202020202050512020202053202020202031173030301e301533202020202010302320202010302320202010303023202047202020202032143030232020103030302320202020201030302320202020103030232020201030301613173030153320103030232020201030303023
202020321416342020202020202010303023202057204720202020202020202020203117303d04043d15335320202047201030163d040417302320202010303016342067202020202020103030232020103030302320202020201030302320202031173030232020201030303030303015332020103030232020201030303023
4041202010301634202020202020103030163420202020204320204220202020202010303d04043d15334720204041202032141e3d04043d1d2320404132143030232020204220202020101e30232020103030301613131313131030302313131317303030232020201030303030301533202020103030232020201030303023
50512020321430163420472020203214303016342042202020202020202052202020103004043d153320202020505120202032141d04041e153367505120103030234445462020202020103030232020103030303030303030301030302330303030303030232020203214303030153320202020103030232020202020202020
20204220203214301634202020202010303030163420202020202020202020202031171d043d15332020202020202020530377323d04043d33202d1c2020103030235455562053202020103030232020321430303030303030301030302330303030303015332020202032111111332020202020103030232020202020202020
20202020202032143016342020202032143030301613131313131313131334202010301e3d15332057522020202020202020204220202020202003772020103030236465662020202020103030232020203211111111111111111030302311111111111133202020202020202020202020202020103030232020202020202020
432020532020203214302320675720203214303030301d1e3030303030301634201030301533202020202020311313133420202020202020203113131313103030231313131334522031173030232020202020202020202020201030302320202020202020202020202020202020202020202020103030232020202020202020
2020202020432020103023202020434220321111111111111111143030303023421030302320422020203113173030301634202020202043311730303030103030233030303016342010303030232020202020202020202020201030301634202020202020202020202020202020202020202020103030232020201030303023
522020202020422010302320404120202020202020205720432032143030302320103030232020202031173030303030302320205320203117303030303010303023301d1e3030232010303030232020202020202020202020201030303016131313131313131313131313181313131334202020103030232020206262626262
20311313133420311730232050512020202020472020202020202032143030232010301533206743201030301511113d1e3d202020203117301e151111111030302311111430302320103030153320202020202020202020202032143030301e3030303030303030303030353030303016342020103030232020206262626262
2010151114161317301533202020202043202020202052202020202010303023201030232020202031173015332020040404202920311730301533202020103030232053103030233117303023202020202020202020202020202032111111111111111111111111111111191111143030232020103030232020201030303023
20102320321111111133202067205320202020205320202020202053103015332010302320404120103030232029201d3d3d202d20103030153320205220103030231c2d103030231030303016342020202020202020202020202020202020202020202020202020202020202020103030232020103030232020201030303023
2010232020202020205320202020202020404120202020202057674710302320201030232050513117301533206720040404202d20103030232020202020103030230377103030231030303030232020202020202020202020202020202020202020202020202020202020202020103030232020103030232020201030303023
2010232029202d201c20202020205220205051202020532044454620103023205310302320203117301533202020203d1e3d202920103030232044454620103030232020103030231030303030163420202020202020202020202020202020202020202020202020202020202031173030232020103030232020201030303023
43102320202047205342203113131313133420202020202054555620103023202010303d0413173015332052202020103023202031173015332054555620103030161313173030231030303030301613342020202020202020202020202020202020202020202020202020203117303030232020103030163420311730303023
20101634202020202020311730151430301613342020202064656620103023202032141d043d1e1533202020202020103016131317303023202064656620103030303d30303030233214303030303030161313131313131313131313131313131320202020201361611313131730303030232020103030301613173030303023
20321416131313131313173015333211111430161313342020202031173023202020323d043d11332020202020202010301d303030301533205320202020321430301d3d3030153320103030303030301e3030303030303030303030303030303020202020203061613030303030303015332020103030301e3d303030303023
2020321111111111111111113343202020321111141e16131313131730153320472020202020202020536720202020321430303015113320202040412020203211111111111133202032143030303030303030303030303030303030303030303020202020203061613030303030301533202020103030303d3d1e3030301533
404120202020572020432020202020202020202032111111111111111133404120202067205220202020202042202057321111113320202020205051202052202020202020204041202032111430303030303030303030301d3030303030303030202020202030616130303030301533202020203214301d3d3d303030153320
5051206752202053202020422020204320202020202020422020202020205051202043202020202020202020202020202020202020432042202020202020205720204320204750512020202032111111111111111111111111111111111111111120202020201161611111111111332020202020203211111111111111332020
__sfx__
0110000000640281552f1502f1322f1121c1751015500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300200027300273002300023000230002300023000230072300723007230000000723007230072300723000670006700023000230002300023000230002300723007230072300000007230072300723007230
010600061827018370184701827018370184701820018200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00101823018420182101843018220184101823018420182101843018220184101823018420182301841000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300200c2730c273002300023000000000000000000000002300023000230002000023000230002300000000670006700023000230000000000000000000000023000230002300020000230002300023000000
010300200c2730c27300232002320c203000000000000000002320023200232002320023200232002320000000672006720023200232000000000000000000000023200232002320023200232002320023200000
01040000094512b055054720737202272054420734202242054220732202222054120731202212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000376740763121175241652d365241352d335241252d325241152d3152105523035131500c030131300c010131101f0702b0702b0402b0302b0222b0121347307473133430734313223072231321307213
011000001f375212752117518275070531335313223131131f0431f5502457024522245123c155006400000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000064021200211001820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800001c4211c4222342223422234221c42223422234222342224422264222342223422214221f4221f42221422214222342223422234222342223422234222342223412000000000010600106301060010630
011800001c4211c4222342223422234221c42223422234222342224422264222342223422214221f4221f42221422214222142221422214222142221422214221565521412000001565500000106651066510666
011800002342223422214222342223422244222442224422234222342221422234222342224422244222442223422234222142223422234222442224422244222342223422214222842228422264222642226422
011800001c4211c4222342223422234221c42223422234222342224422264222342223422214221f4221f4221c4221c4221c4221c4221c4221c4221c4221c4221c4221c412106650000000000106651066510666
0118000021d7021d7021d7021d7021d7021d7021d7021d7021d7021d7021d7021d7021d7021d7021d7021d701fd701fd701fd701fd701fd701fd701fd701fd701cd701cd701cd701cd701fd701fd7020d7020d70
010c00100000000000044300443007430074300000000000094300943002430024300000000000044300443000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800001fd701fd701fd701fd701fd701fd701fd701fd7021d7021d7021d7021d7021d7021d7021d7021d7024d7024d7024d7024d7024d7024d7024d7024d7026d7026d7026d7026d7028d7028d7029d7029d70
010c0010050000500009430094300c4300c43005000050000e4300e43007430074300500005000094300943005000050000500005000050000500005000050000500005000050000500005000050000500005000
010c00001522015220152201522013220132201522015220000000000016220162201622016220162201622015220152201522015220132201322015220152201320013200132201322013220132201322013220
010c0000102201022010220102201d6350e2201022010220000000000011220112201d635112201122011220102201022010220102201d6350e22010220102200e2000e2000e2200e2201d6350e2201d6351d635
010c0000183201a3201c320183201a3201c320183201c3201a3201c3201d3201a3201c3201d3201a3201d3201c3201d3201f3201c3201d3201f3201c3201f3201d3201f320213201d3201f320213201d3201f320
010c00001d63521320213202132021322213221d63521322213222132221322213221d6352130021300213001d6350000013320133201532015320163201632015320153211332111321103210e3210c32100311
0118000000000000001723018231172311523015230172311723017230172321723217232172321d6351d6350000000000172301823117231152301523018231182301a2301a2301c2311c2301a2301a23017230
01180000172301723213230172301723017232152301723017230172321323017230172321823018230172301723015230152301523015232152321523215232152221521200000000001d605106651066510666
0118000000000000001da201da201da2221a2021a2221a2224a2024a2024a2223a2023a2223a221fa201fa221d6051d6051fa201fa201fa2223a2023a2223a2226a2026a2026a2224a2024a2224a2221a2021a22
0118000000000000001da201da201da2221a2021a2221a2224a2024a2024a2223a2023a2223a221fa201fa2220a2020a2020a2220a2220a2220a2220a2220a2223a2023a2023a2223a2223a2223a2223a2223a22
01180000219702197021970219702197021970219702197021970219702197021970219702197021970219701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f970
011800001c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701c9701d9701d9701d9701d9701d9701d9701d9701d9701f9701f9701f9701f9701f9701f9701f9701f970
011800001d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f9701f970
011800001d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d9701d6351d6351c9701c9701c9701c9701c9701c9701c9701c9701d6351c9701c9701d6351c9701c9701d6351d635
010c00200c0030c003112530c003116530c0030c0030c003112530c003112530c003116530c0030c0030c003112530c0031125311253116530c003112530c003116530c003112530c003116530c003112530c003
01180000000001513018130000001a130131300000015130151301513015130151301512015110000000000000000151301c130000001a1301813000000151301513015130151301513015120151100000000000
011800000000011130151300000018130111300000013130000001313017130000001a130131300000015130000001513018130000001a13018130000001a130000001c130000001a13000000181300000015130
011800000000011130151300000018130111300000013130000001313017130000001a130131300000015130000001513018130000001a13018130000001a130000001c130000001a1300000018130000001c130
01180000000001c1351c130000001c130000001c130000001c130000001c130000001c13018130000001a1301a1301a1301a1301a1201a110000000000000000000000000000000000000000000000000001a130
010c0000000000000018130181301a1301a13018130181301a1301a130181301813000000000001a1301a13000000000001c1301c13000000000001a1301a1300000000000181301813000000000001513015130
010c00001513015130151301513015130151301513015130151201512015110151100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000000000000152301523015430154300000000000154301543015230152301443014430132301323000400004001323013230134301343000200002001343013430132301323014430144301523015230
010c00000000000000104301043010230102300040000400102301023010430104300f2300f2300e4300e43000200002000e4300e4300e2300e23000400004000e2300e2300e4300e4300f2300f2301043010430
0118000009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b70
0118000005b7005b7005b7005b7005b7005b7005b7005b7007b7007b7007b7007b7007b7007b7007b7007b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b7009b70
011800000cb700cb700cb700cb700cb700cb700cb700cb700cb700cb700cb700cb700cb700cb700cb700cb7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b7007b70
010c000005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b7005b70
0118000015071150721507215072210712107221072210721f0711f0721f0721f0721a0711a0721a0721a0721d0711d0721d0721d0721d0521d0321a1201c1201d1251d120000001d1221d1221c1201a12018120
0118000015071150721507215072210712107221072210721f0711f0721f0721f072240712407224072240721c0721d0721c0721d0721c0721c0721a1201c1201d1201c1201a1201f1201f1251f1251f12021121
011800001d1351d130000001d1301d1321c1301c1321a1301a1301a1321a1321a1221a11200000181301a1301c1351c130000001c1301c1321a1301a132171301713018130151301513215132151321a1301c130
011800001d1351d130000001d1301d1321c1301c1321a1301a13018130181321a1301a132181301a130181301c1301f1301c1301c1301c1301c1321c1321c1321c1321c6351c112000001c635000001a1301c130
011800001d1351d130000001d1301d1321f1301f13221130211321f1301f1321c1301c13215130151301513017130181301513015130151301513215132151321513215122151120000000000000001a1001c100
0118000021c7021c7021c7021c7021c7021c7021c7021c7024c7024c7024c7024c701cc701cc701cc701cc701dc701dc701dc701dc701dc701dc701dc701dc701f6351fc701fc701f63520c7020c701f6332c610
0118000021c7021c7021c7021c7018c7018c7018c7018c701ac701ac701ac701ac701cc701cc701cc701cc701dc701dc701dc701dc701dc701dc701dc701dc701fc701f6351fc701fc702063320c702063520635
0118000024c7024c7024c7024c7024c7024c7024c7024c701dc701dc701dc701dc701dc701dc701dc701dc7023c7023c7023c7023c7023c7023c7023c7023c701cc701cc701cc701cc701cc701cc701cc701cc70
011800001dc701dc701dc701dc701dc701dc701dc701dc701fc701fc701fc701fc701fc701fc701fc701fc701cc701cc701cc701cc701cc701cc701cc701cc7021c7021c7021c7021c7023c7023c7023c7023c70
011800001c2221c2221c2221c2221c2221c2221d2221f2221c2221c2221c22215222152221522217222172221822218222182221822218222182221a2221c2221a2221a2221a2221a2221c2221c2221522115222
011800001822218222182221822218222182221a2221c2221a2221a2221a2221a2221d2271f2221f2221a2221c2221d2221c2221c2221c2221c2221c2221c2221c2221c2221c2221c2221f2221f2221d2221f222
011800001832218322183221832218322183221c3221c3221a3221a3221a3221a3221a3221a3221a322183021a3211a3221a3251a322183211831117322183221832218322183221831215322153221732217322
01180000183221832218322183221c3221c3221c322183271a3221a3221a3221a3221f3221f3221c3111c3031c3221d3221c3221c3221c3221c3221c3221c3221c3121c3021c3020030015322153221732217322
00180000183221832218322183221c3221c3221c322183271a3221a3221a3221a322133221332213322133221532217322153221532215322153221532215322153121c302182531820318253182031825318253
0118000021d6221d6221d6221d6221d6221d6221d6221d6321d6321d6221d6221d6221d6221d6321d6221d631dd621dd621dd621dd621dd621dd621dd631dd621fd621fd621fd621fd621fd621fd631fd621fd63
011800001cd621cd621cd621cd621cd621cd631cd621cd621fd621fd621fd621fd621fd621f6221fd621fd6221d6221d6221d6221d6221d6221d6321d6221d6221d6321d6221d6221d621fd621fd621fd621f632
011800001167511b5211b521165511b5211b521167511b521365513b5213b521367513b5213b521365513b521067510b5210b521065510b5210b521067510b5211b521165511b5211b521167511b521165511b52
011800001824318b421867518b4218b421865518b4218b421a6751ab421ab421a6551ab421ab421a2731a2431565515b4215b421567515b4215b421565515b4215b421567515b4215b421565515b421567515655
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000000600281052f1002f1022f1021c1051010500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 41420e0a
00 41420e0b
00 4142100c
02 41420e0d
00 41421312
00 41421312
00 41421314
00 41421215
01 41421a16
00 41421b17
00 41421a16
00 41421b17
00 41421c18
02 41421d19
01 411e271f
00 411e2820
00 411e271f
00 411e2821
00 411e2922
00 411e2a23
00 261e2524
00 411e2922
00 411e2a23
00 261e2524
02 411e2625
01 415e302b
00 415e312c
00 415e302b
00 415e312c
00 415e322d
00 415e332e
00 415e322d
02 415e332f
01 415e3934
00 415e3a35
00 415e3934
00 415e3a35
00 415e3b36
00 415e3c37
00 415e3b36
02 415e3c38
01 411e0f11
00 411e0f11
00 411e2922
00 411e2a23
00 261e2524
00 411e2922
00 411e2a23
00 261e2524
02 411e2625
01 411e0f11
00 411e0f11
00 411e271f
00 411e2820
00 411e271f
00 411e2821
00 411e2922
00 411e2a23
00 261e2524
00 411e2922
00 411e2a23
00 261e2524
02 411e2625

