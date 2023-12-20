internal class Conjunction : Node
{
    private Dictionary<Node, Pulse> _memory = new();

    public Conjunction(string name) : base(name)
    {
    }

    public override void RegisterInput(Node input)
    {
        base.RegisterInput(input);
        _memory[input] = Pulse.Low;
    }

    public override IEnumerable<Message> ReceivePulse(Pulse pulse, Node source, int iteration)
    {
        if (name == "hb" && pulse == Pulse.High && _memory[source] == Pulse.Low)
        {
            if (source.name == "rr" && iteration % 3733 == 0)
            {
                Console.WriteLine("expected");
            }else if (source.name == "js" && iteration % 3761 == 0)
            {
                Console.WriteLine("expected");
            }else if (source.name == "bs" && iteration % 4001 == 0)
            {
                Console.WriteLine("expected");
            }else if (source.name == "zb" && iteration % 4021 == 0)
            {
                Console.WriteLine("expected");
            }
            else
            {
                Console.WriteLine($"{iteration} - {name}: signal {source.name} low->high");
                
            }
        }

        _memory[source] = pulse;
        if (_memory.Values.All(p => p == Pulse.High))
        {
            return propogate(Pulse.Low);
        }

        return propogate(Pulse.High);
    }
}