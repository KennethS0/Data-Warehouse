using System;
using System.Data.SqlClient;
using System.Xml;

namespace ExchangeRateBCCR
{
    /// <author>
    ///     JOSUERV99
    /// </author>
    class Program
    {
        /// <summary>
        ///     Synchronize the exchange rate dimension until today before 6am
        /// </summary>
        static void Main(string[] args)
        {
            new Synchronizer().synchronize();
        }
    }
}
