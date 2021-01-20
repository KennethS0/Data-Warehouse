using System;
using System.Xml;

namespace ExchangeRateBCCR
{
    class Program
    {
        static void Main(string[] args)
        {

            /* Dollar purchase value */
            var today = DateTime.Now.ToString("dd/MM/yyyy");
            var responseForDollarPurchase = new Consumer(317, today).consumeWebService();

            var parser = new Parser(responseForDollarPurchase);
            parser.extract();

            Console.WriteLine("Purchase update date : "+parser.updateDate);
            Console.WriteLine("Dollar purchase value: "+parser.value);


            /* Dollar sell value */
            var responseForDollarSell = new Consumer(318, today).consumeWebService();
            parser = new Parser(responseForDollarSell);
            parser.extract();

            Console.WriteLine("Sell update date : "+parser.updateDate);
            Console.WriteLine("Dollar sell value: "+parser.value);

        }
    }
}
