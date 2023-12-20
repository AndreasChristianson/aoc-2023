internal class Dummy : Node
{
    public Pulse lastRecieved = Pulse.High;

    public Dummy() : base("dummy")
    {
    }


    public override IEnumerable<Message> ReceivePulse(Pulse pulse, Node source, int _)
    {
        lastRecieved = pulse;
        return [];
    }
}