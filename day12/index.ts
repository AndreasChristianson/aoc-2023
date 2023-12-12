import * as fs from 'fs';
import {Memoize, clear} from "typescript-memoize";

const parameters = fs.readFileSync('input.txt', 'utf-8')
    .split("\n")
    .filter(line => line.length > 0)
    .map(line => line.split(" "))

enum Spring {
    ok = ".",
    broken = "#",
    unknown = "?"
}

const toSpring = (springString: string): Spring => {
    const ret = Object.entries(Spring)
        .find(([_, value]) => value === springString)
    return ret ? ret[1] : Spring.unknown
}


class HotSpringRow {
    private readonly checkSum: number[];
    private readonly springs: Spring[];

    constructor(dataString: string, checksumString: string) {
        this.checkSum = checksumString
            .split(",")
            .filter(str => str.length > 0)
            .map(sum => parseInt(sum))
        this.springs = dataString
            .split("")
            .map(springString => toSpring(springString))
    }

    @Memoize((...args) => args.join(";"))
    walk(springPos = 0, checkSumPos = 0): number {
        if (springPos == this.springs.length) {
            if (checkSumPos == this.checkSum.length) {
                return 1
            }
            return 0
        }
        switch (this.springs[springPos]) {
            case Spring.ok:
                return this.walk(springPos + 1, checkSumPos)
            case Spring.broken:
                return this.collectBroken(springPos, checkSumPos)
            case Spring.unknown:
                return this.walk(springPos + 1, checkSumPos)
                    + this.collectBroken(springPos, checkSumPos, 0)
        }
    }

    @Memoize((...args) => args.join(";"))
    private collectBroken(springPos: number, checkSumPos: number, brokenCount = 0): number {
        if (springPos === this.springs.length) {
            if (
                this.checkSum[checkSumPos] == brokenCount
                && checkSumPos === this.checkSum.length - 1
            ) {
                return 1
            }
            return 0
        }
        if (checkSumPos === this.checkSum.length) {
            return 0
        }
        if (brokenCount > this.checkSum[checkSumPos]) {
            return 0
        }

        switch (this.springs[springPos]) {
            case Spring.ok:
                if (this.checkSum[checkSumPos] === brokenCount) {
                    return this.walk(springPos, checkSumPos + 1)
                }
                return 0
            case Spring.broken:
                return this.collectBroken(springPos + 1, checkSumPos, brokenCount + 1)
            case Spring.unknown:
                if (this.checkSum[checkSumPos] === brokenCount) {
                    return this.walk(springPos + 1, checkSumPos + 1)
                }
                return this.collectBroken(springPos + 1, checkSumPos, brokenCount + 1)
        }
    }
}

const part1 = parameters
    .map(([dataString, checksumString]) => new HotSpringRow(dataString, checksumString))
    .map(spring => spring.walk())
    .reduceRight((r, l) => r + l);
console.log(part1)

const part2 = parameters
    .map(([dataString, checksumString]) => {
        const bigSprings = Array<string>(5).fill(dataString).join("?")
        const bigChecksums = (checksumString + ",").repeat(5)
        return new HotSpringRow(bigSprings, bigChecksums)
    })
    .map(spring => spring.walk())
    .reduceRight((r, l) => r + l);
console.log(part2)