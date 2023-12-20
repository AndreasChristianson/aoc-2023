internal record Message(Node from, Node to, Pulse pulse)
{
    public override string ToString()
    {
        return $"{from} -> {pulse} -> {to}";
    }
}