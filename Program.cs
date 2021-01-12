using System;
using ExampleProject;

namespace ExampleProject
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Inside Main");
            SomeClass c = new SomeClass();
            c.Method();
        }
    }
}
