package hail3d

import (
	"fmt"
	"math/big"
)

type Point3d struct {
	x *big.Float
	y *big.Float
	z *big.Float
}

func (p *Point3d) String() string {
	return fmt.Sprintf("(%f, %f, %f)", p.x, p.y, p.z)
}

func (p *Point3d) add(o *Point3d) *Point3d {
	return &Point3d{
		x: big.NewFloat(0).Add(p.x, o.x),
		y: big.NewFloat(0).Add(p.y, o.y),
		z: big.NewFloat(0).Add(p.z, o.z),
	}
}

func (p *Point3d) mult(o *Point3d) *Point3d {
	return &Point3d{
		x: big.NewFloat(0).Mul(p.x, o.x),
		y: big.NewFloat(0).Mul(p.y, o.y),
		z: big.NewFloat(0).Mul(p.z, o.z),
	}
}

func (p *Point3d) sub(o *Point3d) *Point3d {
	return &Point3d{
		x: big.NewFloat(0).Sub(p.x, o.x),
		y: big.NewFloat(0).Sub(p.y, o.y),
		z: big.NewFloat(0).Sub(p.z, o.z),
	}
}

func (p *Point3d) MagSquared() *big.Float {
	ret := big.NewFloat(0)
	ret.Mul(p.x, p.x)
	ret.Add(ret, big.NewFloat(0).Mul(p.y, p.y))
	ret.Add(ret, big.NewFloat(0).Mul(p.z, p.z))
	return ret
}

func (p *Point3d) Dot(o *Point3d) *big.Float {
	ret := big.NewFloat(0)
	ret.Mul(p.x, o.x)
	ret.Add(ret, big.NewFloat(0).Mul(p.y, o.y))
	ret.Add(ret, big.NewFloat(0).Mul(p.z, o.z))
	return ret
}

func (p *Point3d) scale(factor *big.Float) *Point3d {
	return &Point3d{
		x: big.NewFloat(0).Mul(p.x, factor),
		y: big.NewFloat(0).Mul(p.y, factor),
		z: big.NewFloat(0).Mul(p.z, factor),
	}
}
