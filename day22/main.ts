import {Piece} from "./piece.ts";

const text = await Deno.readTextFile(Deno.args[0]);
const pieces = text.split('\n')
    .filter(s => s.length > 0)
    .map(Piece.fromLine)
    .sort((l, r) => l.height() - r.height());

pieces.forEach(p => console.log(`${p}`))

for (const piece of pieces) {
    while (piece.height() > 0 && piece.supports.length == 0) {
        // console.log(`Moving piece down ${piece}`)
        piece.lower[2]--;
        piece.upper[2]--;
        piece.detectSupports(pieces)
    }
}

const required = pieces.filter(piece =>
    pieces.filter(p => p.supports.length == 1 && p.supports[0] == piece).length > 0
)

console.log(pieces.filter(piece => !required.includes(piece)).length)

const removePiece = (piece: Piece): number => {
    const removed = [piece]
    let potential = [...pieces]
    let removedCount = 1;
    while (removedCount != 0) {
        removedCount = 0
        for (const p of potential) {
            if (p.supports.length > 0 && p.supports.every(support => removed.includes(support))) {
                removed.push(p)
                removedCount++
                potential = potential.filter(pot => pot !== p)
            }
        }
    }
    return removed.length - 1
}
const falls = pieces
    .map(p => removePiece(p))
// .reduce((l, r) => l + r, 0)
// const sum = pieces.reduce((prev, curr) => prev + removePiece(curr, [curr]), 0)

console.log(falls)
console.log(falls.reduce((l, r) => l + r, 0))