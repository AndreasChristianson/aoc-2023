package com.pessimistic

import java.io.BufferedReader
import java.io.File
import java.util.stream.Collectors

fun main(args: Array<String>) {

    val lines = readLines(args[0])
    val garden = Garden(lines)
    println(garden)
    val beds = garden.walk(64, garden.start)
    println(beds.size)
    val seq=garden
        .planWalk(garden.startLocation)
        .asSequence()
        .withIndex()
        .filter { (it.index-65)%131==0 }
        .take(2)
    for (i in seq){
        println("${i.index}: ${i.value}")
    }

    // observations:
    // steps beds
    //    65 3868
    //   196 34368
    //   327 95262
    //   458 186550
    //   589 308232
    //   720 460308
    //   851 642778
    //first deriv: 30500 60894 91288 121682 152076 182470 // rate of change
    //second deriv: 30394 30394 30394 30394 30394 30394 // rate of rate of change
    /*
    beds'' == 30394
    beds' == 30394 * gardens + c1
    beds == 30394 / 2 * gardens ^ 2 + c1 * gardens + c2
    We define gardens = 0 to be when the first, non-infinite garden wall is hit at steps == 65.
    At that point we had 3868 beds reachable:
    beds(0) == 3868 == 30394 / 2 * 0 ^ 2 + c1 * 0 + c2 == c2
    solve for c1: 15303
     */

    val targetNumberOfSteps: Long = 26501365
    val remainingTarget: Long = targetNumberOfSteps - 65
    val targetNumberOfGardens: Long = remainingTarget / 131
    val bedsVisited = 30394 * targetNumberOfGardens * targetNumberOfGardens / 2 + 15303 * targetNumberOfGardens + 3868
    println(bedsVisited)
}

fun readLines(filename: String): Array<String> {
    val bufferedReader: BufferedReader = File(filename).bufferedReader()
    return bufferedReader.lines().collect(Collectors.toList()).toTypedArray()
}

