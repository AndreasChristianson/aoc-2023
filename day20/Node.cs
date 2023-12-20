using System.Collections;
using System.Threading.Tasks.Dataflow;
using System.Xml;

internal abstract class Node
{
    public override string ToString()
    {
        return $"{name}";
    }

    public readonly List<Node> Outputs = new();
    public readonly List<Node> Inputs = new();
    public readonly string name;

    protected Node(string name)
    {
        this.name = name;
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
    Low,
}