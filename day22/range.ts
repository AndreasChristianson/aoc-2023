export class Range {
    intersect(other: Range): number {
        if (other.lower > this.upper || other.upper < this.lower) {
            return 0;
        }
        return Math.min(this.upper, other.upper)
            - Math.max(this.lower, other.lower)
            + 1
    }

    lower: number;
    upper: number;

    constructor(lower: number, upper: number) {
        this.lower = lower;
        this.upper = upper;
    }
}
