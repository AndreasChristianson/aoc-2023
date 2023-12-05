open System


let lines = System.IO.File.ReadLines("input.txt")


let rec findLine (list: seq<string>, phrase: string) =
    match Seq.toList list with
    | [] -> ""
    | head :: _ when head.Contains(phrase) -> head
    | _ :: tail -> findLine (tail, phrase)

let seedsText = Array.get (findLine(lines, "seeds").Split(":")) 1
let seeds = Seq.toList (seedsText.Trim().Split(" ")) |> List.map Int64.Parse

printfn "seeds: %A" seeds

let mapNames =
    [ "seed-to-soil"
      "soil-to-fertilizer"
      "fertilizer-to-water"
      "water-to-light"
      "light-to-temperature"
      "temperature-to-humidity"
      "humidity-to-location" ]

type Range(low: int64, high: int64) =
    member this.low = low
    member this.high = high
    override this.ToString() = $"(%d{this.low} through %d{this.high})"

type Mapping(line: string) =
    let split = line.Split(" ")
    let source = split[1] |> Int64.Parse
    let dest = split[0] |> Int64.Parse
    let extent = split[2] |> Int64.Parse
    member this.low = source
    member this.high = source + extent - 1L
    member this.translate = fun (sourceValue: int64) -> sourceValue - source + dest

    member this.mapRange =
        fun (sourceRange: Range) ->
            match sourceRange with
            | range when range.high < this.low -> (None, [ range ])
            | range when range.low > this.high -> (None, [ range ])
            | range when range.high <= this.high && range.low >= this.low ->
                (Some(Range(range.low - this.low + dest, range.high - this.low + dest)), [])
            | range when range.high <= this.high ->
                (Some(Range(dest, range.high - this.low + dest)), [ Range(range.low, this.low - 1L) ])
            | range when range.low >= this.low ->
                (Some(Range(range.low - this.low + dest, this.high - this.low + dest)),
                 [ Range(this.high + 1L, range.high) ])
            | range ->
                (Some(Range(dest, this.high - this.low + dest)),
                 [ Range(range.low, this.low - 1L); Range(this.high + 1L, range.high) ])

    member this.covers =
        fun (sourceValue: int64) -> sourceValue >= source && sourceValue < source + extent

    override this.ToString() =
        $"(%d{source} through %d{source + extent - 1L})->(%d{dest} through %d{dest + extent - 1L})"

let parseMapLine (line: string) = Mapping(line)

let rec parseMap (lst: string list) =
    match lst with
    | [] -> []
    | head :: _ when head.Trim().Length = 0 -> []
    | head :: tail -> parseMapLine head :: parseMap tail

let rec collect (text: string, lst: string list) =
    match lst with
    | [] -> []
    | head :: tail when head.Contains(text) -> parseMap tail
    | _ :: tail -> collect (text, tail)

let maps =
    mapNames
    |> List.map (fun name -> $"%s{name} map:")
    |> List.map (fun text -> collect (text, Seq.toList lines))

// printfn $"mappings: %A{maps}"

let applyMappings =
    fun (value: int64) (mappings: Mapping list) ->
        mappings
        |> List.tryFind (fun m -> m.covers value)
        |> fun optionalMapping ->
            match optionalMapping with
            | Some(mapping) -> mapping.translate value
            | None -> value

let locations =
    seeds |> List.map (fun seed -> (seed, List.fold applyMappings seed maps))

printfn $"location mappings: %A{locations}"

let minLocation =
    locations
    |> List.map (fun t ->
        match t with
        | _, r -> r)
    |> List.reduce (fun l r -> Math.Min(l, r))

printfn $"min location: %d{minLocation}"



let seedRanges =
    seeds |> List.chunkBySize 2 |> List.map (fun t -> Range(t[0], t[0] + t[1] - 1L))

printfn $"seedRanges: %A{seedRanges}"



let rec applyRangeMappings (ranges: Range list) (mappings: Mapping list) : Range list =
    match mappings with
    | [] -> ranges
    | head :: tail -> ranges
                      |> List.collect (fun range ->
                          match head.mapRange range with
                          | Some(mappedRange), unmappedRanges -> mappedRange::applyRangeMappings unmappedRanges tail
                          | None, unmappedRanges -> applyRangeMappings unmappedRanges tail)


// ranges
//                       |> List.collect (fun range ->
//                          match head.mapRange range with
//                          | Some(mappedRange), unmappedRanges -> mappedRange :: unmappedRanges |> List.map (fun r -> applyRangeMappings (r, tail))
//                          | None, _ -> applyRangeMappings (range, tail)

let locationsRanges =
    seedRanges
    |> List.collect (fun seedRange -> List.fold applyRangeMappings [ seedRange ] maps)
printfn $"locationsRanges: %A{locationsRanges}"

let minRangeLocation =
    locationsRanges
    |> List.map (fun r -> r.low)
    |> List.reduce (fun l r -> Math.Min(l, r))

printfn $"minRangeLocation: %d{minRangeLocation}"