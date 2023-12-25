package hail3d

import (
	"fmt"
	"math/big"
)

type Hail3d struct {
	p1 *Point3d
	p2 *Point3d
	d  *Point3d
}

func (h *Hail3d) AreParallel(o *Hail3d) bool {
	dx1 := h.d.x
	dy1 := h.d.y
	dz1 := h.d.z
	dx2 := o.d.x
	dy2 := o.d.y
	dz2 := o.d.z
	dxRatio := big.NewFloat(0).Quo(dx1, dx2)
	dyRatio := big.NewFloat(0).Quo(dy1, dy2)
	dzRatio := big.NewFloat(0).Quo(dz1, dz2)
	return dxRatio.Cmp(dyRatio) == 0 && dxRatio.Cmp(dzRatio) == 0
}
func (h *Hail3d) String() string {
	return fmt.Sprintf("(%f - x) / %f = (%f - y) / %f = (%f - z) / %f", h.p1.x, h.d.x, h.p1.y, h.d.y, h.p1.z, h.d.z)
}

func (h *Hail3d) ToSympy(number int) string {
	return fmt.Sprintf(
		"t%[1]d = symbols('t%[1]d')\neq%[1]dx = Eq(t%[1]d * dx + x0, %[3]f * t%[1]d + %[2]f)\neq%[1]dy = Eq(t%[1]d * dy + y0, %[5]f * t%[1]d + %[4]f)\neq%[1]dz = Eq(t%[1]d * dz + z0, %[7]f * t%[1]d + %[6]f)\n",
		number, h.p1.x, h.d.x, h.p1.y, h.d.y, h.p1.z, h.d.z,
	)
}

func det2x2(a *big.Int, b *big.Int, c *big.Int, d *big.Int) *big.Int {
	ret := big.NewInt(0)
	ret.Mul(a, d)
	ret.Sub(ret, big.NewInt(0).Mul(b, c))
	return ret
}

func det3x3(a *big.Int, b *big.Int, c *big.Int, d *big.Int, e *big.Int, f *big.Int, g *big.Int, h *big.Int, i *big.Int) *big.Int {
	ret := big.NewInt(0)
	ret.Mul(a, det2x2(e, f, h, i))
	ret.Sub(ret, big.NewInt(0).Mul(b, det2x2(d, f, g, i)))
	ret.Add(ret, big.NewInt(0).Mul(c, det2x2(d, e, g, h)))
	return ret
}

func FromVectors(x string, y string, z string, dx string, dy string, dz string) *Hail3d {
	p1 := &Point3d{
		x: parseToBigInt(x),
		y: parseToBigInt(y),
		z: parseToBigInt(z),
	}

	d := &Point3d{
		x: parseToBigInt(dx),
		y: parseToBigInt(dy),
		z: parseToBigInt(dz),
	}

	p2 := p1.add(d)
	return &Hail3d{
		p1: p1,
		d:  d,
		p2: p2,
	}
}

func parseToBigInt(str string) *big.Float {
	ret, ok := big.NewFloat(0).SetString(str)
	if !ok {
		panic(fmt.Sprintf("unable to parse bigint: [%s]", str))
	}
	return ret
}

var fudge = big.NewFloat(0.001)

func (h *Hail3d) Intersection(o *Hail3d) (*Hail3d, bool) {

	p1 := h.p1
	p2 := h.p2
	p3 := o.p1
	p4 := o.p2

	p13 := p1.sub(p3)
	p43 := p4.sub(p3)
	p21 := p2.sub(p1)
	if p43.MagSquared().Cmp(fudge) == -1 {
		return nil, false
	}
	if p21.MagSquared().Cmp(fudge) == -1 {
		return nil, false
	}
	d1343 := p13.Dot(p43)
	d4321 := p43.Dot(p21)
	d1321 := p13.Dot(p21)
	d2121 := p21.Dot(p21)
	d4343 := p43.Dot(p43)
	denom := big.NewFloat(0).Mul(d2121, d4343)
	denom = denom.Sub(denom, big.NewFloat(0).Mul(d4321, d4321))
	if big.NewFloat(0).Abs(denom).Cmp(fudge) == -1 {
		return nil, false
	}
	numer := big.NewFloat(0).Mul(d1343, d4321)
	numer = numer.Sub(numer, big.NewFloat(0).Mul(d1321, d4343))
	mua := big.NewFloat(0).Quo(numer, denom)
	mub := big.NewFloat(0).Mul(d4321, mua)
	mub = mub.Add(mub, d1343)
	mub = mub.Quo(mub, d4343)
	pA := p21.scale(mua).add(p1)
	pB := p43.scale(mub).add(p3)

	distance := (pA.sub(pB)).MagSquared()
	distance.Sqrt(distance)

	if distance.Cmp(fudge) == -1 {
		return &Hail3d{
			p1: pA,
			p2: pB,
			d:  pA.sub(pB),
		}, true
	}
	return nil, false
}
