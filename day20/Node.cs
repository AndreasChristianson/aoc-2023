internal abstract class Node
{
    public readonly List<Node> Inputs = new();
    public readonly string name;

    public readonly List<Node> Outputs = new();

    protected Node(string name)
    {
        this.name = name;
    }

    public override string ToString()
    {
        return $"{name}";
    }

    public virtual void RegisterInput(Node input)
    {
        Inputs.Add(input);
    }

    public void RegisterOutput(Node output)
    {
        Outputs.Add(output);
    }

    public abstract IEnumerable<Message> ReceivePulse(Pulse pulse, Node source, int iteration);

    public static Node fromString(string type, string name)
    {
        switch (type)
        {
            case "%": return new FlipFlop(name);
            case "&": return new Conjunction(name);
            case "": return new Broadcast(name);
            default: throw new NotImplementedException();
        }
    }

    protected IEnumerable<Message> propogate(Pulse pulse)
    {
        return Outputs.Select(output => new Message(this, output, pulse));
    }
}

internal enum Pulse
{
    High,
    Low
}