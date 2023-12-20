internal class FlipFlop : Node
{
    enum Status
    {
        On,
        Off,
    }

    private Status _status = Status.Off;

    public FlipFlop(string name) : base(name)
    {
    }

    public override IEnumerable<Message> ReceivePulse(Pulse pulse, Node source, int _)
    {
        switch (pulse)
        {
            case Pulse.High:
                return [];
            case Pulse.Low:
                return propogate(flipFlop());
        }

        throw new InvalidOperationException();
    }

    private Pulse flipFlop()
    {
        switch (_status)
        {
            case Status.On:
                _status = Status.Off;
                return Pulse.Low;
            case Status.Off:
                _status = Status.On;
                return Pulse.High;
        }

        throw new InvalidOperationException();
    }
}