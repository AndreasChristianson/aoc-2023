import {Range} from "./range.ts";

export class Piece {
    supporting: Piece[] = [];

    detectSupports(pieces: Piece[]) {
        this.supports = pieces.filter(p => p != this)
            .filter(p => p.topHeight() + 1 == this.height())
            .filter(p => p.xyIntersection(this) > 0)
        this.supports.forEach(piece => piece.supporting.push(this))
    }

    topHeight() {
        return this.upper[2];
    }

    xyIntersection(other: Piece): number {
        return other.range(0).intersect(this.range(0))
            * other.range(1).intersect(this.range(1))
    }

    range(dim: number): Range {
        return new Range(this.lower[dim], this.upper[dim]);
    }

    supports: Piece[] = [];

    height(): number {
        return this.lower[2];
    }

    vol(): number {
        return Math.abs(this.extents().map(n => n + 1).reduce((prev, curr) => prev * curr, 1))
    }

    extents(): [number, number, number] {
        return [this.upper[0] - this.lower[0], this.upper[1] - this.lower[1], this.upper[2] - this.lower[2]]
    }

    lower: [number, number, number];
    upper: [number, number, number];

    constructor(lower: [number, number, number], upper: [number, number, number]) {
        this.lower = lower;
        this.upper = upper;
    }

    public static fromLine(line: string): Piece {
        const points: number[][] = line.split('~').map(str => str.split(',').map(s => parseInt(s)))
        return new Piece(points[0] as [number, number, number], points[1] as [number, number, number]).standardize();
    }

    standardize(): Piece {
        return new Piece([
            Math.min(this.lower[0], this.upper[0]),
            Math.min(this.lower[1], this.upper[1]),
            Math.min(this.lower[2], this.upper[2])], [
            Math.max(this.lower[0], this.upper[0]),
            Math.max(this.lower[1], this.upper[1]),
            Math.max(this.lower[2], this.upper[2])
        ])
    }

    public toString = (): string => {
        return `piece ${this.lower} to ${this.upper} (vol: ${this.vol()}, height: ${this.height()})`;
    }
}
