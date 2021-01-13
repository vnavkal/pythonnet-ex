using Azure.Storage.Blobs; //used for step 2
using System;
using System.IO;

namespace ExampleProject
{
    public class SomeClass
    {
        public bool Method()
        {
            /* step 1 */
            Console.WriteLine("Inside SomeClass.Method");

            /* step 2 */
            BlobContainerClient container = new BlobContainerClient("****connectionstring****", "code");
            Console.WriteLine(container.Exists());
            return true;
        }
    }
}
