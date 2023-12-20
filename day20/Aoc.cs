using System.Text.RegularExpressions;

internal class Aoc
{
    private static readonly Regex rx = new(@"^(?<type>[%&]?)(?<name>\w*) -> (?<destinations>.*)$");
    private readonly Node broadcaster;
    private int buttonCount;
    private readonly Dummy dummy = new();
    private Node hb;
    private int high;
    private int low;


    private Aoc(IEnumerable<string> lines)
    {
        Dictionary<string, Node> nodes = new();
        Dictionary<Node, string[]> links = new();
        foreach (var line in lines)
        {
            var matches = rx.Matches(line);
            var type = matches[0].Groups["type"].Value;
            var name = matches[0].Groups["name"].Value;
            var destinations = matches[0].Groups["destinations"].Value.Split(", ");
            var node = Node.fromString(type, name);
            nodes[name] = node;
            links[node] = destinations;
        }

        foreach (var link in links)
        {
            var node = link.Key;

            foreach (var name in link.Value)
            {
                if (!nodes.ContainsKey(name))
                {
                    Console.WriteLine($"[{name}] not found. Using dummy");
                    node.RegisterOutput(dummy);
                    continue;
                }

                nodes[name].RegisterInput(node);
                node.RegisterOutput(nodes[name]);
            }
        }

        broadcaster = nodes["broadcaster"];
        hb = nodes["hb"];
    }

    private static void Main(string[] args)
    {
        var nodes = new Dictionary<string, Node>();


        var lines = File.ReadLines(args[0]);
        var aoc = new Aoc(lines);

        for (var i = 0; i < 1000; i++) aoc.propogate();

        Console.WriteLine($"low: {aoc.low}, high: {aoc.high}, product: {aoc.high * aoc.low}");

        // var aoc2 = new Aoc(lines);
        //
        // while (aoc2.dummy.lastRecieved!=Pulse.Low)
        // {
        //     aoc2.propogate();
        // }
        Console.WriteLine($"button count: {Helpers.LCM([3733, 3761, 4001, 4021])}");
    }

    private void propogate()
    {
        var queue = new Queue<Message>();
        buttonCount++;

        queue.Enqueue(new Message(null!, broadcaster, Pulse.Low));

        while (queue.Count > 0)
        {
            var message = queue.Dequeue();
            var newMessages = message.to.ReceivePulse(message.pulse, message.from, buttonCount);
            switch (message.pulse)
            {
                case Pulse.Low:
                    low++;
                    break;
                case Pulse.High:
                    high++;
                    break;
            }

            foreach (var newMessage in newMessages) queue.Enqueue(newMessage);
        }
    }
}