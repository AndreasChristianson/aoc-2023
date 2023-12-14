Imports System
Imports System.IO

Public Enum Direction
    North
    South
    East
    West
End Enum

Public Module Tile
    Public Enum Tile
        Empty
        Round
        Square
    End Enum


    Public Function TileFromString(asString As String) As Tile
        Select Case asString
            Case "#"
                return Tile.Square
            Case "O"
                return Tile.Round
        End Select
        return Tile.Empty
    End Function

    Public Function TileToString(tile As Tile) As String
        Select Case tile
            Case Tile.Round
                return "O"
            Case tile.Square
                return "#"
        End Select
        return "."
    End Function
End Module

Public Class Platform
    Public Sub New(lines As String())
        Width = lines.First().Length
        Height = lines.Length
        Dim newGrid = New Tile.Tile(Height*Width) {}
        For row = 0 To Height - 1
            Dim line = lines(row)
            For col = 0 To Width - 1
                Dim tileString = line.Chars(col)
                Dim tile = TileFromString(tileString)
                If not tile.Equals(day14.Tile.Tile.Empty)
                    newGrid(row*Width + col) = tile
                End If
            Next
        Next
        Grid = newGrid
    End Sub

    Private Sub New(newGrid As Tile.Tile(), width As Integer, height As Integer)
        Grid = newGrid
        Me.Width = width
        me.Height = height
    End Sub

    Public Overrides Function ToString() As String
        Dim str = ""
        For row = 0 To Height - 1
            For col = 0 To Width - 1
                str = str + TileToString(Grid(row*Width + col))
            Next
            str = str + Environment.NewLine
        Next
        return str
    End Function

    Public Function NorthLoad() As Integer
        Dim load = 0
        For row = 0 To Height - 1
            For col = 0 To Width - 1
                If Grid(row*Width + col).Equals(Tile.Tile.Round)
                    load += Height - row
                End If
            Next
        Next
        return load
    End Function

    Public Function Cycle() As Platform
        Dim p = me
        p = p.Tilt(Direction.North)
        p = p.Tilt(Direction.West)
        p = p.Tilt(Direction.South)
        p = p.Tilt(Direction.East)
        return p
    End Function

    Public Function Tilt(dir As Direction) As Platform
        Dim newGrid = New Tile.Tile(Height*Width) {}
        Select Case dir
            Case Direction.North
                For row = 0 To Height - 1
                    For col = 0 To Width - 1
                        Dim tile = Grid(row*Width + col)
                        Select Case tile
                            Case day14.Tile.Tile.Square
                                newGrid(row*Width + col) = day14.Tile.Tile.Square
                            Case day14.Tile.Tile.Round
                                Dim destination = row
                                For checkRow = row - 1 To 0 Step - 1
                                    If newGrid(checkRow*Width + col).Equals(day14.Tile.Tile.Empty)
                                        destination = checkRow
                                    Else
                                        Exit For
                                    End If
                                Next
                                newGrid(destination*Width + col) = tile
                        End Select
                    Next
                Next
                return New Platform(newGrid, Width, Height)
            Case Direction.South
                For row = Height - 1 To 0 Step - 1
                    For col = 0 To Width - 1
                        Dim tile = Grid(row*Width + col)
                        Select Case tile
                            Case day14.Tile.Tile.Square
                                newGrid(row*Width + col) = day14.Tile.Tile.Square
                            Case day14.Tile.Tile.Round
                                Dim destination = row
                                For checkRow = row + 1 To Height - 1 Step 1
                                    If newGrid(checkRow*Width + col).Equals(day14.Tile.Tile.Empty)
                                        destination = checkRow
                                    Else
                                        Exit For
                                    End If
                                Next
                                newGrid(destination*Width + col) = tile
                        End Select
                    Next
                Next
                return New Platform(newGrid, Width, Height)
            Case Direction.East
                For col = Width - 1 To 0 Step - 1
                    For row = 0 To Height - 1
                        Dim tile = Grid(row*Width + col)
                        Select Case tile
                            Case day14.Tile.Tile.Square
                                newGrid(row*Width + col) = day14.Tile.Tile.Square
                            Case day14.Tile.Tile.Round
                                Dim destination = col
                                For checkCol = col + 1 To Width - 1 Step 1
                                    If newGrid(row*Width + checkCol).Equals(day14.Tile.Tile.Empty)
                                        destination = checkCol
                                    Else
                                        Exit For
                                    End If
                                Next
                                newGrid(row*Width + destination) = tile
                        End Select
                    Next
                Next
                return New Platform(newGrid, Width, Height)
            Case Direction.West
                For col = 0 To Width - 1 Step 1
                    For row = 0 To Height - 1 Step 1
                        Dim tile = Grid(row*Width + col)
                        Select Case tile
                            Case day14.Tile.Tile.Square
                                newGrid(row*Width + col) = day14.Tile.Tile.Square
                            Case day14.Tile.Tile.Round
                                Dim destination = col
                                For checkCol = col - 1 To 0 Step - 1
                                    If newGrid(row*Width + checkCol).Equals(day14.Tile.Tile.Empty)
                                        destination = checkCol
                                    Else
                                        Exit For
                                    End If
                                Next
                                newGrid(row*Width + destination) = tile
                        End Select
                    Next
                Next
                return New Platform(newGrid, Width, Height)
        End Select
        Throw New Exception()
    End Function

    Private Property Grid As Tile.Tile()
    Private ReadOnly Property Width As Integer
    Private ReadOnly Property Height As Integer

    Public Function Hash() As Integer
        Dim hashValue = 0
        For row = 0 To Height - 1
            For col = 0 To Width - 1
                hashValue += col*row*Grid(row*Width + col)
            Next
        Next
        return hashValue
    End Function
End Class


Module Program
    Sub Main()
        Dim path = "input.txt"
        Dim platform = ReadPlatform(path)
        Console.WriteLine(platform)
        Dim tilted = platform.Tilt(Direction.North)
        Console.WriteLine(tilted)
        Console.WriteLine(tilted.NorthLoad())
        Dim lastCycle = platform
        Dim seen = New Dictionary(Of Integer,(Platform, Integer))()
        Dim target = 1_000_000_000
        For i = 0 To target
            Console.WriteLine(String.Format("{0}: {1} = {2}", i, lastCycle.Hash(), lastCycle.NorthLoad()))
            Dim newPlatform = lastCycle.Cycle()
            Dim hash = newPlatform.Hash()
            if seen.ContainsKey(hash)
                Console.WriteLine(
                    String.Format("{0}: {1} = {2} CYCLE DETECTED", i, newPlatform.Hash(), newPlatform.NorthLoad()))
                Dim tuple = seen(hash)
                Dim cycleLength = i - tuple.Item2
                Dim cycleBreakPoint = (target - tuple.Item2) mod cycleLength
                For Each t As (Platform, Integer) in seen.Values
                    If t.Item2 = cycleBreakPoint + tuple.Item2 - 1
                        Console.WriteLine(String.Format("{0}: {1} = {2}", target, t.Item1.Hash(), t.Item1.NorthLoad()))
                        return
                    End If
                Next
            End If
            seen(hash) = (newPlatform, i)
            lastCycle = newPlatform
        Next
    End Sub

    Private Function ReadPlatform(path As String) As Platform
        Dim readText() As String = File.ReadAllLines(path)
        return New Platform(readText)
    End Function
End Module
