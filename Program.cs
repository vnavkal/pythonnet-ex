using Azure.Storage.Blobs; //used for step 2
using Newtonsoft.Json.Linq;
using System;

namespace ExampleProject
{
    public class Program
    {
        static void Main(string[] args)
        {
            /* step 1 */
            Console.WriteLine(".Net standard 2.0");
            JArray array = new JArray();
            array.Add("Manual text");
            array.Add(new DateTime(2000, 5, 23));
            JObject o = new JObject();
            o["MyArray"] = array;
            string json = o.ToString();
            Console.WriteLine(json);

            /* step 2 */
            BlobContainerClient container = new BlobContainerClient("****connectionstring****", "code");
            Console.WriteLine(container.Exists());
        }
    }
}
