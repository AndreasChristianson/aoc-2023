public class Helpers
{
    public static long LCM(long[] numbers)
    {
        return numbers.Aggregate(lcm);
    }

    private static long lcm(long a, long b)
    {
        return Math.Abs(a * b) / GCD(a, b);
    }

    private static long GCD(long a, long b)
    {
        return b == 0 ? a : GCD(b, a % b);
    }
}