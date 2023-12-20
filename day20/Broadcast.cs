internal class Broadcast : Node
{
    public Broadcast(string name) : base(name)
    {
    }

    public override IEnumerable<Message> ReceivePulse(Pulse pulse, Node source, int _)
    {
        return propogate(pulse);
    }
}