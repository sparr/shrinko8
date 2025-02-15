pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

--------------------------------------
-- Please see 'Commented Source Code' section in the BBS
-- for the original commented source code
-- (The below had the comments stripped due to cart size limits)
--------------------------------------
local t, nx, n3 = _ENV, {}, {}
for n, e in pairs(_ENV) do
  nx[n] = e
  if (type(e) == "function") n3[n] = true
end
local _ENV = nx
z, W = true

function f(t, e)
  for n = 1, #e do
    if (sub(e, n, n) == t) return n
  end
end

function e(t, n)
  return sub(t, n, n)
end

local nm, n7 = split "a,b,f,n,r,t,v,\\,\",',\n,*,#,-,|,+,^", split "⁷,⁸,ᶜ,\n,\r,	,ᵇ,\\,\",',\n,¹,²,³,⁴,⁵,⁶"
local nx = {}
for n = 1, #nm do
  nx[nm[n]] = n7[n]
end

function g(n)
  return n >= "0" and n <= "9"
end

function B(n)
  return n >= "A" and n <= "Z" or n >= "a" and n <= "z" or n == "_" or n >= "█" or g(n)
end

function nd(r, n, i, o)
  local t = ""
  while n <= #r do
    local l = e(r, n)
    if (l == i) break
    if l == "\\" then
      n += 1
      local t = e(r, n)
      l = nx[t]
      if t == "x" then
        t = tonum("0x" .. sub(r, n + 1, n + 2))
        if (t) n += 2 else o "bad hex escape"
        l = chr(t)
      elseif g(t) then
        local i = n
        while g(t) and n < i + 3 do
          n += 1
          t = e(r, n)
        end
        n -= 1
        t = tonum(sub(r, i, n))
        if (not t or t >= 256) o "bad decimal escape"
        l = chr(t)
      elseif t == "z" then
        repeat
          n += 1
          t = e(r, n)
        until not f(t, " \r	ᶜᵇ\n")
        if (t == "") o()
        l = ""
        n -= 1
      elseif t == "" then
        o()
        l = ""
      end
      if (not l) o("bad escape: " .. t); l = ""
    elseif l == "\n" then
      o "unterminated string"
      break
    end
    t ..= l
    n += 1
  end
  if (n > #r) o("unterminated string", true)
  return t, n + 1
end

function Y(t, n, l, r)
  if e(t, n) == "[" then
    n += 1
    local o = n
    while (e(t, n) == "=") n += 1
    local r = "]" .. sub(t, o, n - 1) .. "]"
    local o = #r
    if e(t, n) == "[" then
      n += 1
      if (e(t, n) == "\n") n += 1
      local e = n
      while (n <= #t and sub(t, n, n + o - 1) ~= r) n += 1
      if (n >= #t) l()
      return sub(t, e, n - 1), n + o
    end
  end
  if (r) l "invalid long brackets"
  return nil, n
end

function nn(l, c)
  local n, s, i = 1, 1
  local o, h, b, p, u = {}, {}, {}, {}

  local function d(n, e)
    if (c) ne(n, i)
    u = n and not e
  end

  while n <= #l do
    i = n
    local t = e(l, n)
    local a, r
    if f(t, " \r	ᶜᵇ\n") then
      n += 1
      a = true
      if (t == "\n") s += 1
    elseif t == "-" and e(l, n + 1) == "-" then
      n += 2
      if (e(l, n) == "[") r, n = Y(l, n, d)
      if not r then
        while (n <= #l and e(l, n) ~= "\n") n += 1
      end
      if (c) a = true else add(o, true)
    elseif g(t) or t == "." and g(e(l, n + 1)) then
      local u, a = "0123456789", true
      if t == "0" and f(e(l, n + 1), "xX") then
        u ..= "AaBbCcDdEeFf"
        n += 2
      elseif t == "0" and f(e(l, n + 1), "bB") then
        u = "01"
        n += 2
      end
      while true do
        t = e(l, n)
        if t == "." and a then
          a = false
        elseif not f(t, u) then
          break
        end
        n += 1
      end
      r = sub(l, i, n - 1)
      if (not tonum(r)) d "bad number"; r = "0"
      add(o, tonum(r))
    elseif B(t) then
      while B(e(l, n)) do
        n += 1
      end
      add(o, sub(l, i, n - 1))
    elseif t == "'" or t == '"' then
      r, n = nd(l, n + 1, t, d)
      add(o, {t = r})
    elseif t == "[" and f(e(l, n + 1), "=[") then
      r, n = Y(l, n, d, true)
      add(o, {t = r})
    else
      n += 1
      local e, r, u = unpack(split(sub(l, n, n + 2), ""))
      if e == t and r == t and f(t, ".>") then
        n += 2
        if (u == "=" and f(t, ">")) n += 1
      elseif e == t and r ~= t and f(t, "<>") and f(r, "<>") then
        n += 2
        if (u == "=") n += 1
      elseif e == t and f(t, ".:^<>") then
        n += 1
        if (r == "=" and f(t, ".^<>")) n += 1
      elseif e == "=" and f(t, "+-*/\\%^&|<>=~!") then
        n += 1
      elseif f(t, "+-*/\\%^&|<>=~#(){}[];,?@$.:") then
      else
        d("bad char: " .. t)
      end
      add(o, sub(l, i, n - 1))
    end
    if (not a) add(h, s); add(b, i); add(p, n - 1)
    if (u) o[#o], u = false, false
  end
  return o, h, b, p
end

function r(t, n)
  for e = 1, #n do
    if (n[e] == t) return e
  end
end

function c(n)
  return unpack(n, 1, n.n)
end

function nu(e)
  local n = {}
  for t, l in next, e do
    n[t] = l
  end
  return n
end

local Y = split "and,break,do,else,elseif,end,false,for,function,goto,if,in,local,nil,not,or,repeat,return,then,true,until,while"
G = {}
for n in all(Y) do
  G[n] = true
end

local function Y(n)
  return type(n) == "string" and e(n, #n) == "="
end

nt = split "end,else,elseif,until"

function nl(n, j)
  local o, F, l = nn(n, true)
  local n, f, s, y, h, Z = 1, 0, 0
  local t, b
  local v, d, p, x = {}

  local function i(e)
    ne(e, l[n - 1] or 1)
  end

  local function g(n)
    return function()
      return n
    end
  end

  local function C(e)
    local n = d[e]
    if n then
      return function(t)
        return t[n][e]
      end
    else
      n = d._ENV
      return function(t)
        return t[n]._ENV[e]
      end
    end
  end

  local function q()
    local n = d["..."]
    if (not n or n ~= Z) i "unexpected '...'"
    return function(e)
      return c(e[n]["..."])
    end
  end

  local function D(e)
    local n = d[e]
    if n then
      return function(t)
        return t[n], e
      end
    else
      n = d._ENV
      return function(t)
        return t[n]._ENV, e
      end
    end
  end

  local function l(e)
    local t = o[n]
    n += 1
    if (t == e) return
    if (t == nil) i()
    i("expected: " .. e)
  end

  local function u(t)
    if (not t) t = o[n]; n += 1
    if (t == nil) i()
    if (type(t) == "string" and B(e(t, 1)) and not G[t]) return t
    if (type(t) == "string") i("invalid identifier: " .. t)
    i "identifier expected"
  end

  local function e(t)
    if (o[n] == t) n += 1; return true
  end

  local function A()
    d = setmetatable({}, {__index = d})
    f += 1
  end

  local function B()
    d = getmetatable(d).__index
    f -= 1
  end

  local function m(r, l)
    local e = {}
    local n = #l
    for t = 1, n - 1 do
      e[t] = l[t](r)
    end
    if n > 0 then
      local t = pack(l[n](r))
      if t.n ~= 1 then
        for l = 1, t.n do
          e[n + l - 1] = t[l]
        end
        n += t.n - 1
      else
        e[n] = t[1]
      end
    end
    e.n = n
    return e
  end

  local function k(t)
    local n = {}
    add(n, (t()))
    while e "," do
      add(n, (t()))
    end
    return n
  end

  local function X(r, o, i)
    local n = {}
    if i then
      add(n, i)
    elseif not e ")" then
      while true do
        add(n, (t()))
        if (e ")") break
        l ","
      end
    end
    if o then
      return function(e)
        local t = r(e)
        return t[o](t, c(m(e, n)))
      end, true, nil, function(e)
        local t = r(e)
        return t[o], pack(t, c(m(e, n)))
      end
    else
      return function(e)
        return r(e)(c(m(e, n)))
      end, true, nil, function(e)
        return r(e), m(e, n)
      end
    end
  end

  local function G()
    local r, d = {}, {}
    local c, a = 1
    while not e "}" do
      a = nil
      local i, f
      if e "[" then
        i = t()
        l "]"
        l "="
        f = t()
      elseif o[n + 1] == "=" then
        i = g(u())
        l "="
        f = t()
      else
        i = g(c)
        f = t()
        c += 1
        a = #r + 1
      end
      add(r, i)
      add(d, f)
      if (e "}") break
      if (not e ";") l ","
    end
    return function(e)
      local t = {}
      for n = 1, #r do
        if n == a then
          local o, l = r[n](e), pack(d[n](e))
          for n = 1, l.n do
            t[o + n - 1] = l[n]
          end
        else
          t[r[n](e)] = d[n](e)
        end
      end
      return t
    end
  end

  local function E(o, a)
    local n, p, t
    if o then
      if a then
        A()
        n = u()
        d[n] = f
        t = D(n)
      else
        n = {u()}
        while (e ".") add(n, u())
        if (e ":") add(n, u()); p = true
        if #n == 1 then
          t = D(n[1])
        else
          local e = C(n[1])
          for t = 2, #n - 1 do
            local l = e
            e = function(e)
              return l(e)[n[t]]
            end
          end
          t = function(t)
            return e(t), n[#n]
          end
        end
      end
    end
    local n, r = {}
    if (p) add(n, "self")
    l "("
    if not e ")" then
      while true do
        if (e "...") r = true else add(n, u())
        if (e ")") break
        l ","
        if (r) i "unexpected param after '...'"
      end
    end
    A()
    for e in all(n) do
      d[e] = f
    end
    if (r) d["..."] = f
    local e, i, d = v, h, Z
    v, h, Z = {}, s + 1, f
    local u = b()
    for n in all(v) do
      n()
    end
    v, h, Z = e, i, d
    l "end"
    B()
    return function(e)
      if (a) add(e, {})
      local l = nu(e)
      local i = #l
      local f = function(...)
        local t = pack(...)
        local e = l
        if #e ~= i then
          local n = {}
          for t = 0, i do
            n[t] = e[t]
          end
          e = n
        end
        local l = {}
        for e = 1, #n do
          l[n[e]] = t[e]
        end
        if (r) l["..."] = pack(unpack(t, #n + 1, t.n))
        add(e, l)
        local n = u(e)
        deli(e)
        if n then
          if (type(n) == "table") return c(n)
          return n()
        end
      end
      if (o) local n, l = t(e); n[l] = f else return f
    end
  end

  local function Z()
    local e = o[n]
    n += 1
    local n
    if (e == nil) i()
    if (e == "nil") return g()
    if (e == "true") return g(true)
    if (e == "false") return g(false)
    if (type(e) == "number") return g(e)
    if (type(e) == "table") return g(e.t)
    if (e == "{") return G()
    if (e == "(") n = t(); l ")"; return function(e) return (n(e)) end, true
    if (e == "-") n = t(11); return function(e) return -n(e) end
    if (e == "~") n = t(11); return function(e) return ~n(e) end
    if (e == "not") n = t(11); return function(e) return not n(e) end
    if (e == "#") n = t(11); return function(e) return #n(e) end
    if (e == "@") n = t(11); return function(e) return @n(e) end
    if (e == "%") n = t(11); return function(e) return %n(e) end
    if (e == "$") n = t(11); return function(e) return $n(e) end
    if (e == "function") return E()
    if (e == "...") return q()
    if (e == "\\") n = u(); return function() return na(n) end, true, function() return nc(n) end
    if (u(e)) return C(e), true, D(e)
    i("unexpected token: " .. e)
  end

  local function D(e, t, l, r)
    local n
    if (e == "^" and t <= 12) n = r(12); return function(e) return l(e) ^ n(e) end
    if (e == "*" and t < 10) n = r(10); return function(e) return l(e) * n(e) end
    if (e == "/" and t < 10) n = r(10); return function(e) return l(e) / n(e) end
    if (e == "\\" and t < 10) n = r(10); return function(e) return l(e) \ n(e) end
    if (e == "%" and t < 10) n = r(10); return function(e) return l(e) % n(e) end
    if (e == "+" and t < 9) n = r(9); return function(e) return l(e) + n(e) end
    if (e == "-" and t < 9) n = r(9); return function(e) return l(e) - n(e) end
    if (e == ".." and t <= 8) n = r(8); return function(e) return l(e) .. n(e) end
    if (e == "<<" and t < 7) n = r(7); return function(e) return l(e) << n(e) end
    if (e == ">>" and t < 7) n = r(7); return function(e) return l(e) >> n(e) end
    if (e == ">>>" and t < 7) n = r(7); return function(e) return l(e) >>> n(e) end
    if (e == "<<>" and t < 7) n = r(7); return function(e) return l(e) <<> n(e) end
    if (e == ">><" and t < 7) n = r(7); return function(e) return l(e) >>< n(e) end
    if (e == "&" and t < 6) n = r(6); return function(e) return l(e) & n(e) end
    if (e == "^^" and t < 5) n = r(5); return function(e) return l(e) ~ n(e) end
    if (e == "|" and t < 4) n = r(4); return function(e) return l(e) | n(e) end
    if (e == "<" and t < 3) n = r(3); return function(e) return l(e) < n(e) end
    if (e == ">" and t < 3) n = r(3); return function(e) return l(e) > n(e) end
    if (e == "<=" and t < 3) n = r(3); return function(e) return l(e) <= n(e) end
    if (e == ">=" and t < 3) n = r(3); return function(e) return l(e) >= n(e) end
    if (e == "==" and t < 3) n = r(3); return function(e) return l(e) == n(e) end
    if ((e == "~=" or e == "!=") and t < 3) n = r(3); return function(e) return l(e) ~= n(e) end
    if (e == "and" and t < 2) n = r(2); return function(e) return l(e) and n(e) end
    if (e == "or" and t < 1) n = r(1); return function(e) return l(e) or n(e) end
  end

  local function q(d, e, a)
    local i = o[n]
    n += 1
    local r, f
    if a then
      if (i == ".") r = u(); return function(n) return e(n)[r] end, true, function(n) return e(n), r end
      if (i == "[") r = t(); l "]"; return function(n) return e(n)[r(n)] end, true, function(n) return e(n), r(n) end
      if (i == "(") return X(e)
      if (i == "{" or type(i) == "table") n -= 1; f = Z(); return X(e, nil, f)
      if i == ":" then
        r = u()
        if (o[n] == "{" or type(o[n]) == "table") f = Z(); return X(e, r, f)
        l "("
        return X(e, r)
      end
    end
    local l = D(i, d, e, t)
    if (not l) n -= 1
    return l
  end

  t = function(o)
    local n, e, t, l = Z()
    while true do
      local r, i, f, d = q(o or 0, n, e)
      if (not r) break
      n, e, t, l = r, i, f, d
    end
    return n, t, l
  end

  local function Z()
    local e, n = t()
    if (not n) i "cannot assign to value"
    return n
  end

  local function q()
    local n = k(Z)
    l "="
    local e = k(t)
    if #n == 1 and #e == 1 then
      return function(t)
        local l, r = n[1](t)
        l[r] = e[1](t)
      end
    else
      return function(t)
        local l, r = {}, {}
        for e = 1, #n do
          local o, i = n[e](t)
          add(l, o)
          add(r, i)
        end
        local o = m(t, e)
        for e = #n, 1, -1 do
          l[e][r[e]] = o[e]
        end
      end
    end
  end

  local function G(e, l)
    local r = o[n]
    n += 1
    local o = sub(r, 1, -2)
    local n = D(o, 0, e, function()
      return t()
    end)
    if (not n) i "invalid compound assignment"
    return function(e)
      local t, r = l(e)
      t[r] = n(e)
    end
  end

  local function H()
    if e "function" then
      return E(true, true)
    else
      local n = k(u)
      local l = e "=" and k(t) or {}
      A()
      for e = 1, #n do
        d[n[e]] = f
      end
      if #n == 1 and #l == 1 then
        return function(e)
          add(e, {[n[1]] = l[1](e)})
        end
      else
        return function(e)
          local t = {}
          local r = m(e, l)
          for e = 1, #n do
            t[n[e]] = r[e]
          end
          add(e, t)
        end
      end
    end
  end

  local function D(e)
    local t = F[n - 1]
    x = function()
      return t ~= F[n]
    end
    if (not e or x()) i(n <= #o and "bad shorthand" or nil)
  end

  local function F()
    local r = o[n] == "("
    local o = t()
    local t, n
    if e "then" then
      t, n = b()
      if e "else" then
        n = b()
        l "end"
      elseif e "elseif" then
        n = F()
      else
        l "end"
      end
    else
      D(r)
      t = b()
      if (not x() and e "else") n = b()
      x = nil
    end
    return function(e)
      if o(e) then
        return t(e)
      elseif n then
        return n(e)
      end
    end
  end

  local function Z(...)
    local n = y
    y = s + 1
    local e = b(...)
    y = n
    return e
  end

  local function X(n, e)
    if (n == true) return
    return n, e
  end

  local function I()
    local r = o[n] == "("
    local o = t()
    local n
    if e "do" then
      n = Z()
      l "end"
    else
      D(r)
      n = Z()
      x = nil
    end
    return function(e)
      while o(e) do
        if (stat(1) >= 1) w()
        local t, l = n(e)
        if (t) return X(t, l)
      end
    end
  end

  local function D()
    local r = f
    local o = Z(true)
    l "until"
    local l = t()
    while (f > r) B()
    return function(n)
      repeat
        if (stat(1) >= 1) w()
        local e, t = o(n)
        if (not e) t = l(n)
        while (#n > r) deli(n)
        if (e) return X(e, t)
      until t
    end
  end

  local function J()
    if o[n + 1] == "=" then
      local r = u()
      l "="
      local o = t()
      l ","
      local i = t()
      local u = e "," and t() or g(1)
      l "do"
      A()
      d[r] = f
      local t = Z()
      l "end"
      B()
      return function(n)
        for e = o(n), i(n), u(n) do
          if (stat(1) >= 1) w()
          add(n, {[r] = e})
          local e, l = t(n)
          deli(n)
          if (e) return X(e, l)
        end
      end
    else
      local r = k(u)
      l "in"
      local o = k(t)
      l "do"
      A()
      for n in all(r) do
        d[n] = f
      end
      local i = Z()
      l "end"
      B()
      return function(n)
        local e = m(n, o)
        while true do
          local l = {}
          local t = {e[1](e[2], e[3])}
          if (t[1] == nil) break
          e[3] = t[1]
          for n = 1, #r do
            l[r[n]] = t[n]
          end
          if (stat(1) >= 1) w()
          add(n, l)
          local e, t = i(n)
          deli(n)
          if (e) return X(e, t)
        end
      end
    end
  end

  local function g()
    if (not y or h and y < h) i "break outside of loop"
    return function()
      return true
    end
  end

  local function y()
    if (not h and not j) i "return outside of function"
    if o[n] == ";" or r(o[n], nt) or x and x() then
      return function()
        return pack()
      end
    else
      local r, n, l = t()
      local n = {r}
      while (e ",") add(n, (t()))
      if #n == 1 and l and h then
        return function(n)
          local e, t = l(n)
          if (stat(1) >= 1) w()
          return function()
            return e(c(t))
          end
        end
      else
        return function(e)
          return m(e, n)
        end
      end
    end
  end

  local function A(e)
    local n = u()
    l "::"
    if (p[n] and p[n].e == s) i "label already defined"
    p[n] = {l = f, e = s, o = e, r = #e}
  end

  local function Z()
    local t = u()
    local e, l, n = p, f
    add(v, function()
      n = e[t]
      if (not n) i "label not found"
      if (h and n.e < h) i "goto outside of function"
      local t = e[n.e] or l
      if (n.l > t and n.r < #n.o) i "goto past local"
    end)
    return function()
      if (stat(1) >= 1) w()
      return 0, n
    end
  end

  local function u(f)
    local r = o[n]
    n += 1
    if (r == ";") return
    if (r == "do") local n = b(); l "end"; return n
    if (r == "if") return F()
    if (r == "while") return I()
    if (r == "repeat") return D()
    if (r == "for") return J()
    if (r == "break") return g()
    if (r == "return") return y(), true
    if (r == "local") return H()
    if (r == "goto") return Z()
    if (r == "::") return A(f)
    if (r == "function" and o[n] ~= "(") return E(true)
    if r == "?" then
      local e, l = C "print", k(t)
      return function(n)
        e(n)(c(m(n, l)))
      end
    end
    n -= 1
    local f = n
    local l, d, r = t()
    if e "," or e "=" then
      n = f
      return q()
    elseif Y(o[n]) then
      return G(l, d)
    elseif s <= 1 and z then
      return function(e)
        local n = pack(l(e))
        if (not (r and n.n == 0)) add(a, n)
        W = n[1]
      end
    else
      if (not r) i "statement has no effect"
      return function(n)
        l(n)
      end
    end
  end

  b = function(t)
    p = setmetatable({}, {__index = p})
    p[s] = f
    s += 1
    local d = s
    local i = t and 32767 or f
    local l = {}
    while n <= #o and not r(o[n], nt) and not (x and x()) do
      local n, t = u(l)
      if (n) add(l, n)
      if (t) e ";"; break
    end
    while (f > i) B()
    s -= 1
    p = getmetatable(p).__index
    return function(e)
      local t, n
      local r, o = 1, #l
      while r <= o do
        t, n = l[r](e)
        if t then
          if (type(t) ~= "number") break
          if (n.e ~= d) break
          r = n.r
          while (#e > n.l) deli(e)
          t, n = nil
        end
        r += 1
      end
      while (#e > i) deli(e)
      return t, n
    end
  end
  d = z and {_ENV = 0, _env = 0, _ = 0} or {_ENV = 0}
  local e = b()
  if (n <= #o) i "unexpected end"
  for n in all(v) do
    n()
  end
  return function(n)
    local t = z and {_ENV = n, _env = n, _ = W} or {_ENV = n}
    local n = e {[0] = t}
    if (n) return c(n)
  end
end

O, P = 10, false
local W = {["\0"] = "000", ["ᵉ"] = "014", ["ᶠ"] = "015"}
for n, e in pairs(nx) do
  if (not f(n, "'\n")) W[e] = n
end

function n1(n)
  local t = 1
  while t <= #n do
    local l = e(n, t)
    local e = W[l]
    if (e) n = sub(n, 1, t - 1) .. "\\" .. e .. sub(n, t + 1); t += #e
    t += 1
  end
  return '"' .. n .. '"'
end

function ns(n)
  if (type(n) ~= "string") return false
  if (G[n]) return false
  if (#n == 0 or g(e(n, 1))) return false
  for t = 1, #n do
    if (not B(e(n, t))) return false
  end
  return true
end

function Z(e, t)
  local n = type(e)
  if n == "nil" then
    return "nil"
  elseif n == "boolean" then
    return e and "true" or "false"
  elseif n == "number" then
    return tostr(e, P)
  elseif n == "string" then
    return n1(e)
  elseif n == "table" and not t then
    local n = "{"
    local l = 0
    local r = 0
    for t, o in next, e do
      if (l == O) n = n .. ",<...>"; break
      if (l > 0) n = n .. ","
      local e = Z(o, 1)
      if t == r + 1 then
        n = n .. e
        r = t
      elseif ns(t) then
        n = n .. t .. "=" .. e
      else
        n = n .. "[" .. Z(t, 1) .. "]=" .. e
      end
      l += 1
    end
    return n .. "}"
  else
    return "<" .. tostr(n) .. ">"
  end
end

function nh(n, e)
  if (e == nil) return n
  if (not n) n = ""
  local t = min(21, #e)
  for l = 1, t do
    if (#n > 0) n ..= "\n"
    local t = e[l]
    if type(t) == "table" then
      local e = ""
      for n = 1, t.n do
        if (#e > 0) e = e .. ", "
        e = e .. Z(t[n])
      end
      n ..= e
    else
      n ..= t
    end
  end
  local l = {}
  for n = t + 1, #e do
    l[n - t] = e[n]
  end
  return n, l
end

poke(24365, 1)
cls()
d = "> "
n, s, k = "", 1, 0
l, v = 1, 20
u, y = {""}, 1
X = false
h, o = 0, 1
H, I = true, true
i = {7, 4, 3, 5, 6, 8, 5, 12, 14, 7, 11, 5}
t.print = function(n, ...)
  if (pack(...).n ~= 0 or not H) return print(n, ...)
  add(a, tostr(n))
end

function nr()
  poke(24368, 1)
end

function no()
  return function()
    if (stat(30)) return stat(31)
  end
end

function Q(r, i)
  local t = 1
  local n, l = 0, 0
  if (not r) return t, n, l
  while t <= #r do
    local o = e(r, t)
    local e = o >= "█"
    if (n >= (e and 31 or 32)) l += 1; n = 0
    if (i) i(t, o, n, l)
    if o == "\n" then
      l += 1
      n = 0
    else
      n += e and 2 or 1
    end
    t += 1
  end
  return t, n, l
end

function C(o, l)
  local n, e = 0, 0
  local i, r, t = Q(o, function(t, i, r, o)
    if (l == t) n, e = r, o
  end)
  if (l >= i) n, e = r, t
  if (r > 0) t += 1
  return n, e, t
end

function D(i, r, e)
  local t = 1
  local n = false
  local o, f, l = Q(i, function(o, f, i, l)
    if (e == l and r == i and not n) t = o; n = true
    if ((e < l or e == l and r < i) and not n) t = o - 1; n = true
  end)
  if (not n) t = e >= l and o or o - 1
  if (f > 0) l += 1
  return t, l
end

function R(n, t, l, e)
  if type(e) == "function" then
    Q(n, function(n, r, o, i)
      print(r, t + o * 4, l + i * 6, e(n))
    end)
  else
    print(n and "⁶rw" .. n, t, l, e)
  end
end

function n0(n, o, f)
  local d, t, u, l = nn(n)
  local t = 1
  R(n, o, f, function(o)
    while t <= #l and l[t] < o do
      t += 1
    end
    local n
    if (t <= #l and u[t] <= o) n = d[t]
    local t = i[5]
    if n == false then
      t = i[6]
    elseif n == true then
      t = i[7]
    elseif type(n) ~= "string" or r(n, {"nil", "true", "false"}) then
      t = i[8]
    elseif G[n] then
      t = i[9]
    elseif not B(e(n, 1)) then
      t = i[10]
    elseif n3[n] then
      t = i[11]
    end
    return t
  end)
end

function _draw()
  local u = peek(24357)
  local c, p = peek2(24360), peek2(24362)
  camera()

  local function e(n)
    cursor(0, 127)
    for e = 1, n do
      rectfill(0, o * 6, 127, (o + 1) * 6 - 1, 0)
      if o < 21 then
        o += 1
      else
        print ""
      end
    end
  end

  local function w(n, e)
    for t = 1, n do
      if (o > e) o -= 1
      rectfill(0, o * 6, 127, (o + 1) * 6 - 1, 0)
    end
  end

  local function m(n, e)
    for t = 0, 2 do
      local l = pget(n + t, e + 5)
      pset(n + t, e + 5, l == 0 and i[12] or 0)
    end
  end

  local function f(u)
    local r = d .. n .. " "
    local f, t, n = C(r, #d + l)
    if n > s then
      e(n - s)
    elseif n < s then
      w(s - n, n)
    end
    s = n
    k = mid(k, 0, max(s - 21, 0))
    ::again::
    local e = o - s + k
    if (e + t < 0) k += 1; goto again
    if (e + t >= 21) k -= 1; goto again
    local n = e * 6
    rectfill(0, n, 127, n + s * 6 - 1, 0)
    if (s > 21) rectfill(0, 126, 127, 127, 0)
    n0(r, 0, n)
    print(d, 0, n, i[4])
    if (v >= 10 and u ~= false and not x) m(f * 4, n + t * 6)
  end

  local function d(t)
    e(1)
    o -= 1
    print("[enter] ('esc' to abort)", 0, o * 6, i[3])
    while true do
      flip()
      nr()
      for n in no() do
        if (n == "•") X = true; b = ""; a = {}; return false
        if (n == "\r" or n == "\n") h += t; return true
      end
    end
  end

  ::again::
  local r, t
  if a or b then
    r, t = D(b, 0, h)
    if t - h <= 20 and a then
      b, a = nh(b, a)
      r, t = D(b, 0, h)
      if (#a == 0 and not x) a = nil
    end
  end
  if (not x) camera()
  if (h == 0 and not x) f(not b)
  if b then
    local u = sub(b, r)
    local r = min(t - h, 20)
    e(r)
    R(u, 0, (o - r) * 6, i[1])
    if r < t - h then
      if (d(r)) goto again
    else
      local d, u, t = C(J, 0)
      e(t)
      R(J, 0, (o - t) * 6, i[2])
      if x then
        h += r
      else
        n, s, k, l, h, b, J = "", 0, 0, 1, 0
        f()
      end
    end
  end
  if x then
    e(1)
    o -= 1
    print(x, 0, o * 6, i[3])
  end
  if A then
    e(1)
    o -= 1
    print(A, 0, o * 6, i[3])
    A = nil
  end
  if K then
    K -= 1
    if (K == 0) A, K = ""
  end
  v -= 1
  if (v == 0) v = 20
  color(u)
  camera(c, p)
  if (o <= 20) cursor(0, o * 6)
end

L, E, F = false, false, false
j = {}

function ne(n, e)
  m, n2 = n, e
  assert(false, n)
end

function S(n, e, l)
  return nl(n, l)(e or t)
end

function T(n, e)
  return S("return " .. n, e, true)
end

function nb(t)
  local l = cocreate(nl)
  ::_::
  local n, e = coresume(l, t)
  if (n and not e) goto _
  if (not n) e, m = m, false
  return n, e
end

function np(n, e)
  local t, l = C(n, e)
  return "line " .. l + 1 .. " col " .. t + 1
end

function ni(e, l)
  a, X, m = {}, false, false
  L, E, F = false, false, false
  local t = cocreate(function()
    S(e)
  end)
  local r, n
  while true do
    r, n = coresume(t)
    if (costatus(t) == "dead") break
    if H and not E then
      x = "running, press 'esc' to abort"
      _draw()
      flip()
      x = nil
    else
      if (I and not E and not F) flip()
      if (not I and holdframe) holdframe()
      F = false
    end
    for n in no() do
      if n == "•" then
        X = true
      else
        add(j, n)
      end
    end
    if (X) n = "computation aborted"; break
  end
  if m == nil then
    if (l) n = "unexpected end of code" else n, a = nil
  end
  if (m) n, m = m .. "\nat " .. np(e, n2)
  J = n
  j = {}
end

w = function()
  L = true
  yield()
  L = false
end
t.flip = function(...)
  local n = pack(flip(...))
  F = true
  w()
  return c(n)
end
t.coresume = function(n, ...)
  local e = pack(coresume(n, ...))
  while L do
    yield()
    e = pack(coresume(n))
  end
  m = false
  return c(e)
end
t.stat = function(n, ...)
  if n == 30 then
    return #j > 0 or stat(n, ...)
  elseif n == 31 then
    if #j > 0 then
      return deli(j, 1)
    else
      local e = stat(n, ...)
      if (e == "•") X = true
      return e
    end
  else
    return stat(n, ...)
  end
end

function nw(n)
  if (_set_fps) _set_fps(n._update60 and 60 or 30)
  if (n._init) n._init()
  E = true
  while true do
    if (_update_buttons) _update_buttons()
    if (holdframe) holdframe()
    if n._update60 then
      n._update60()
    elseif n._update then
      n._update()
    end
    if (n._draw) n._draw()
    flip()
    F = true
    w()
  end
  E = false
end

function na(e)
  if r(e, {"i", "interrupt"}) then
    return H
  elseif r(e, {"f", "flip"}) then
    return I
  elseif r(e, {"r", "repl"}) then
    return z
  elseif r(e, {"mi", "max_items"}) then
    return O
  elseif r(e, {"h", "hex"}) then
    return P
  elseif r(e, {"cl", "colors"}) then
    return i
  elseif r(e, {"c", "code"}) then
    local e = {[0] = n}
    for n = 1, #u - 1 do
      e[n] = u[#u - n]
    end
    return e
  elseif r(e, {"cm", "compile"}) then
    return function(n)
      return nb(n)
    end
  elseif r(e, {"x", "exec"}) then
    return function(n, e)
      S(n, e)
    end
  elseif r(e, {"v", "eval"}) then
    return function(n, e)
      return T(n, e)
    end
  elseif r(e, {"p", "print"}) then
    return function(n, ...)
      t.print(Z(n), ...)
    end
  elseif r(e, {"ts", "tostr"}) then
    return function(n)
      return Z(n)
    end
  elseif r(e, {"rst", "reset"}) then
    run()
  elseif r(e, {"run"}) then
    nw(t)
  else
    assert(false, "unknown \\-command")
  end
end

function nc(e)
  local function t(n)
    return n and n ~= 0 and true or false
  end

  local n
  if r(e, {"i", "interrupt"}) then
    n = function(n)
      H = t(n)
    end
  elseif r(e, {"f", "flip"}) then
    n = function(n)
      I = t(n)
    end
  elseif r(e, {"r", "repl"}) then
    n = function(n)
      z = t(n)
    end
  elseif r(e, {"mi", "max_items"}) then
    n = function(n)
      O = tonum(n) or -1
    end
  elseif r(e, {"h", "hex"}) then
    n = function(n)
      P = t(n)
    end
  elseif r(e, {"cl", "colors"}) then
    n = function(n)
      i = n
    end
  else
    assert(false, "unknown \\-command assign")
  end
  local e = {__newindex = function(t, l, e)
    n(e)
  end}
  return setmetatable(e, e), 0
end

M = stat(4)
q, N = 0, false
poke(24412, 10, 2)

function p(n)
  if stat(28, n) then
    if (n ~= U) U, q = n, 0
    return q == 0 or q >= 10 and q % 2 == 0
  elseif U == n then
    U = nil
  end
end

function _update()
  local t = false

  local function r(o)
    local t, e, r = C(d .. n, #d + l)
    if (V) t = V
    e += o
    if (not (e >= 0 and e < r)) return false
    l = max(D(d .. n, t, e) - #d, 1)
    V = t
    v = 20
    return true
  end

  local function f(r)
    local e, o = C(d .. n, #d + l)
    e = r > 0 and 100 or 0
    l = max(D(d .. n, e, o) - #d, 1)
    t = true
  end

  local function c(r)
    u[y] = n
    y += r
    n = u[y]
    if r < 0 then
      l = #n + 1
    else
      l = max(D(d .. n, 32, 0) - #d, 1)
      local t = e(n, l)
      if (t ~= "" and t ~= "\n") l -= 1
    end
    t = true
  end

  local function d()
    if #n > 0 then
      if (#u > 50) del(u, u[1])
      u[#u] = n
      add(u, "")
      y = #u
      t = true
    end
  end

  local function s(e)
    if l + e > 0 then
      n = sub(n, 1, l + e - 1) .. sub(n, l + e + 1)
      l += e
      t = true
    end
  end

  local function o(e)
    n = sub(n, 1, l - 1) .. e .. sub(n, l)
    l += #e
    t = true
  end

  local i = stat(28, 224) or stat(28, 228)
  local h = stat(28, 225) or stat(28, 229)
  local e = -1
  if p(80) then
    if (l > 1) l -= 1; t = true
  elseif p(79) then
    if (l <= #n) l += 1; t = true
  elseif p(82) then
    if ((i or not r(-1)) and y > 1) c(-1)
  elseif p(81) then
    if ((i or not r(1)) and y < #u) c(1)
  else
    local r = stat(31)
    e = ord(r)
    if r == "•" then
      if #n == 0 then
        extcmd "pause"
      else
        a, J = {}
        d()
      end
    elseif r == "\r" or r == "\n" then
      if h then
        o "\n"
      else
        ni(n)
        if (not a) o "\n" else d()
      end
    elseif i and p(40) then
      ni(n, true)
      d()
    elseif r ~= "" and e >= 32 and e < 154 then
      if (N and e >= 128) r = chr(e - 63)
      o(r)
    elseif e == 193 then
      o "\n"
    elseif e == 192 then
      f(-1)
    elseif e == 196 then
      f(1)
    elseif e == 203 then
      N = not N
      A, K = "shift now selects " .. (N and "punycase" or "symbols"), 40
    elseif p(74) then
      if (i) l = 1; t = true else f(-1)
    elseif p(77) then
      if (i) l = #n + 1; t = true else f(1)
    elseif p(42) then
      s(-1)
    elseif p(76) then
      s(0)
    end
  end
  local r = stat(4)
  if (r ~= M or e == 213) o(r); M = r
  if e == 194 or e == 215 then
    if n ~= "" and n ~= M then
      M = n
      printh(n, "@clip")
      if (e == 215) n = ""; l = 1
      A = "press again to put in clipboard"
    else
      A = ""
    end
  end
  if stat(120) then
    local n
    repeat
      n = serial(2048, 24448, 128)
      o(chr(peek(24448, n)))
    until n == 0
  end
  if (t) v, V = 20
  q += 1
  nr()
end

function nf(n, e)
  local t, l = coresume(cocreate(e))
  if not t then
    printh("error #" .. n .. ": " .. l)
    print("error #" .. n .. "\npico8 broke something again,\nthis cart may not work.\npress any button to ignore")
    while (btnp() == 0) flip()
    cls()
  end
end

nf(1, function()
  assert(pack(T "(function (...) return ... end)(1,2,nil,nil)").n == 4)
end)
nf(2, function()
  assert(T "function() local temp, temp2 = {max(1,3)}, -20;return temp[1] + temp2; end" () == -17)
end)
printh "finished"
stop()
while true do
  if (holdframe) holdframe()
  _update()
  _draw()
  flip()
end

__meta:title__
keep:------------------------------------
keep: Please see 'Commented Source Code' section in the BBS