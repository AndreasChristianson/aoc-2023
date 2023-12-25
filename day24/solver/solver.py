
from sympy import *

dx, dy, dz = symbols('dx dy dz')
x0, y0, z0 = symbols('0x y0 z0')
eqs = []
t0 = symbols('t0')
eq0x = Eq(t0 * dx + x0, 21.000000 * t0 + 368925240582247.000000)
eq0y = Eq(t0 * dy + y0, -126.000000 * t0 + 337542061908847.000000)
eq0z = Eq(t0 * dz + z0, -9.000000 * t0 + 298737178993847.000000)

eqs.extend((eq0x, eq0y, eq0z))
t1 = symbols('t1')
eq1x = Eq(t1 * dx + x0, -21.000000 * t1 + 287668477092999.000000)
eq1y = Eq(t1 * dy + y0, -15.000000 * t1 + 306868689869154.000000)
eq1z = Eq(t1 * dz + z0, 29.000000 * t1 + 240173335647821.000000)

eqs.extend((eq1x, eq1y, eq1z))
t2 = symbols('t2')
eq2x = Eq(t2 * dx + x0, -25.000000 * t2 + 172063062341522.000000)
eq2y = Eq(t2 * dy + y0, -38.000000 * t2 + 378381220662744.000000)
eq2z = Eq(t2 * dz + z0, -64.000000 * t2 + 223621999511007.000000)

eqs.extend((eq2x, eq2y, eq2z))
t3 = symbols('t3')
eq3x = Eq(t3 * dx + x0, 161.000000 * t3 + 173207142739382.000000)
eq3y = Eq(t3 * dy + y0, -145.000000 * t3 + 380138705823962.000000)
eq3z = Eq(t3 * dz + z0, 90.000000 * t3 + 212955454913987.000000)

eqs.extend((eq3x, eq3y, eq3z))
t4 = symbols('t4')
eq4x = Eq(t4 * dx + x0, -69.000000 * t4 + 247022614384315.000000)
eq4y = Eq(t4 * dy + y0, 522.000000 * t4 + 185370784055125.000000)
eq4z = Eq(t4 * dz + z0, 316.000000 * t4 + 147179140524802.000000)

eqs.extend((eq4x, eq4y, eq4z))
print(solve(eqs))
