means(a,z).    means(z,a).
means(b,y).    means(y,b).
means(c,x).    means(x,c).
means(d,w).    means(w,d).
means(e,v).    means(v,e).
means(f,u).    means(u,f).
means(g,t).    means(t,g).
means(h,s).    means(s,h).
means(i,r).    means(r,i).
means(j,q).    means(q,j).
means(k,p).    means(p,k).
means(l,o).    means(o,l).
means(m,n).    means(n,m).

decode([],[]).
decode([H1|T1], [H2| T2]) :-
    means(H1, H2),
    decode(T1, T2).

