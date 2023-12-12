import * as fs from 'fs';
import {Memoize, clear} from "typescript-memoize";

// export function hello(who: string = world): string {
//     return `Hello ${who}! `;
// }


const allContents = fs.readFileSync('input.txt', 'utf-8');

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
    checkSum: number[];
    private springs: Spring[];

    constructor(dataString: string, checksumString: string) {

        this.checkSum = checksumString
            .split(",")
            .filter(str => str.length > 0)
            .map(sum => parseInt(sum))
        this.springs = dataString
            .split("")
            .map(springString => toSpring(springString))
    }

    @Memoize({
            hashFunction: (springPos: number, checkSumPos: number) => {
                return springPos + ";" + checkSumPos ;
            },
            tags: ["row"]
        }
    )
    walk(springPos = 0, checkSumPos = 0): number {
        // console.log("walking at ", springPos, checkSumPos)
        if (springPos == this.springs.length) {
            // console.log("walk: at end of row ")
            if (checkSumPos == this.checkSum.length) {
                // console.log(row, " Accepted while walking!")
                return 1
            }
            // console.log(row, " under checksum count")
            return 0
        }
        switch (this.springs[springPos]) {
            case Spring.ok:
                return this.walk(springPos + 1, checkSumPos)
            case Spring.broken:
                return this.collectBroken(springPos, checkSumPos)
            case Spring.unknown:
                return this.walk(springPos + 1, checkSumPos) + this.collectBroken(springPos, checkSumPos, 0)
        }
    }

    @Memoize({
            hashFunction: (springPos: number, checkSumPos: number, brokenCount: number) => {
                return springPos + ";" + checkSumPos + ";"+ brokenCount;
            },
            tags: ["row"]
        }
    )
    private collectBroken(springPos: number, checkSumPos: number, brokenCount = 0): number {
        // console.log("collecting at ", springPos, checkSumPos, brokenCount)
        if (springPos == this.springs.length) {
            // console.log("collect: at end of row")
            if (this.checkSum[checkSumPos] == brokenCount && checkSumPos === this.checkSum.length - 1) {
                // console.log(row, " Accepted while collecting!")
                return 1
            }
            // console.log(row, " incomplete broken threshold at end of row")
            return 0
        }
        if (checkSumPos === this.checkSum.length) {
            // console.log(row, " exceeded checksum count")
            return 0
        }
        if (brokenCount > this.checkSum[checkSumPos]) {
            // console.log(row, " exceeded broken threshold")
            return 0
        }

        switch (this.springs[springPos]) {
            case Spring.ok:
                if (this.checkSum[checkSumPos] == brokenCount) {
                    // console.log("complete broken threshold at working spring")
                    return this.walk(springPos, checkSumPos + 1)
                }
                // console.log(row, " incomplete broken threshold at working spring")
                return 0
            case Spring.broken:
                // console.log("continuing to collect")
                return this.collectBroken(springPos + 1, checkSumPos, brokenCount + 1)
            case Spring.unknown:
                if (this.checkSum[checkSumPos] == brokenCount) {
                    // console.log(" complete broken threshold at unknown spring")
                    return this.walk(springPos + 1, checkSumPos + 1)
                }
                // console.log("incomplete broken threshold at unknown spring")
                return this.collectBroken(springPos + 1, checkSumPos, brokenCount + 1)
        }
    }
}

const part1 = allContents.split("\n")
    .filter(line => line.length > 0)
    .map(line => {
        const [dataString, checksumString] = line
            .split(" ")
        const spring = new HotSpringRow(dataString, checksumString)
        console.log(spring)
        clear(["row"])
        const count = spring.walk()
        console.log(count)
        return count
    })
console.log(part1)
console.log(part1.reduceRight((left, right) => left + right))

const part2 = allContents.split("\n")
    .filter(line => line.length > 0)
    .map(line => {
        const [dataString, checksumString] = line
            .split(" ")
        const bigSprings = Array<string>(5).fill(dataString).join("?")
        const bigChecksums = (checksumString + ",").repeat(5)
        const spring = new HotSpringRow(bigSprings, bigChecksums)
        console.log(spring)
        clear(["row"])
        const count = spring.walk()
        console.log(count)
        return count
    })
console.log(part2)
console.log(part2.reduceRight((left, right) => left + right))