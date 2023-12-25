package hail2d

import (
	"fmt"
	"math"
)

const fudge = 0.0001

type Hail2d struct {
	x float64
	y float64
	//z  float64
	dx float64
	dy float64
	//dz float64
	x2 float64
	y2 float64
	//z2 float64
}

func (h *Hail2d) getIntersectionDenom(o *Hail2d) float64 {
	return det(
		det(h.x, 1, h.x2, 1),
		det(h.y, 1, h.y2, 1),
		det(o.x, 1, o.x2, 1),
		det(o.y, 1, o.y2, 1),
	)
}
func (h *Hail2d) ToString() string {
	return fmt.Sprintf("(%f,%f)@(%f,%f)", h.x, h.y, h.dx, h.dy)
}
func (h *Hail2d) GetIntersection(o *Hail2d) (float64, float64) {
	denom := h.getIntersectionDenom(o)
	if math.Abs(denom) < fudge {
		return 0, 0
	}
	return det(
			det(h.x, h.y, h.x2, h.y2),
			det(h.x, 1, h.x2, 1),
			det(o.x, o.y, o.x2, o.y2),
			det(o.x, 1, o.x2, 1),
		) / denom,
		det(
			det(h.x, h.y, h.x2, h.y2),
			det(h.y, 1, h.y2, 1),
			det(o.x, o.y, o.x2, o.y2),
			det(o.y, 1, o.y2, 1),
		) / denom
}

func (h *Hail2d) Direction(x float64, y float64) int {
	if x > h.x && h.dx > 0 {
		return 1
	}
	if x < h.x && h.dx < 0 {
		return 1
	}
	if y > h.y && h.dy > 0 {
		return 1
	}
	if y < h.y && h.dy < 0 {
		return 1
	}
	if math.Abs(y-h.y) < fudge && math.Abs(x-h.x) < fudge { //happening now!
		return 0
	}
	if h.dx == 0 && h.dy == 0 { //point not line
		return 0
	}
	return -1
}

func FromVectors(x float64, y float64, z float64, dx float64, dy float64, dz float64) *Hail2d {
	return &Hail2d{
		x: x,
		y: y,
		//z:  z,
		dx: dx,
		dy: dy,
		//dz: dz,
		x2: x + dx*10000,
		y2: y + dy*10000,
		//z2: z + dz*10000,
	}
}

func det(a float64, b float64, c float64, d float64) float64 {
	return a*d - b*c
}
